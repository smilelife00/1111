import sys
import pymysql
import hashlib
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QVBoxLayout, QLabel, QLineEdit, QMessageBox
import configparser

class RegisterWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()
        self.db_manager = DatabaseManager()

    def initUI(self):
        self.setWindowTitle('用户注册')
        self.setGeometry(100, 100, 300, 150)

        layout = QVBoxLayout()

        self.username_label = QLabel('用户名:', self)
        layout.addWidget(self.username_label)
        self.username_input = QLineEdit(self)
        layout.addWidget(self.username_input)

        self.password_label = QLabel('密码:', self)
        layout.addWidget(self.password_label)
        self.password_input = QLineEdit(self)
        self.password_input.setEchoMode(QLineEdit.Password)
        layout.addWidget(self.password_input)

        self.register_button = QPushButton('注册', self)
        self.register_button.clicked.connect(self.register)
        layout.addWidget(self.register_button)

        self.setLayout(layout)

    def register(self):
        username = self.username_input.text()
        password = self.password_input.text()

        if not username or not password:
            QMessageBox.warning(self, '错误', '用户名和密码不能为空！')
            return

        salt = 'random_salt'  # 实际使用时应该生成一个随机的盐值
        password_hash = hashlib.sha256((password + salt).encode('utf-8')).hexdigest()

        try:
            insert_query = '''
            INSERT INTO users (username, password_hash, salt)
            VALUES (%s, %s, %s)
            '''
            self.db_manager.execute_query(insert_query, (username, password_hash, salt))
            QMessageBox.information(self, '成功', '注册成功！')
        except Exception as e:
            QMessageBox.critical(self, '失败', f'注册失败！\n错误信息: {str(e)}')

def main():
    
    app = QApplication(sys.argv)
    load_stylesheet(app)
    ex = RegisterWindow()
    ex.show()
    sys.exit(app.exec_())
#链接数据库
class DatabaseManager:
    def __init__(self):
        config = configparser.ConfigParser()
        config.read('config.ini')
        
        self.host = config['database']['host']
        self.user = config['database']['user']
        self.password = config['database']['password']
        self.db = config['database']['db']
        self.connect()  # 在初始化时调用连接方法

    def connect(self):
        """建立到数据库的新连接。"""
        self.conn = pymysql.connect(host=self.host, user=self.user, password=self.password, db=self.db, connect_timeout=60)
        self.conn.autocommit(True)

    def ensure_connection(self):
        """确保连接处于活动状态，如果需要则重新连接。"""
        try:
            self.conn.ping(reconnect=True)
        except:
            self.connect()  # 如果ping失败，则重新连接

    def __del__(self):
        self.conn.close()

    def begin_transaction(self):
        self.conn.autocommit(False)

    def commit_transaction(self):
        self.conn.commit()
        self.conn.autocommit(True)

    def rollback_transaction(self):
        self.conn.rollback()
        self.conn.autocommit(True)

    def execute_query(self, query, params=()):
        self.ensure_connection()  # 在执行查询之前确保连接处于活动状态
        cursor = self.conn.cursor()
        try:
            cursor.execute(query, params)
            result = cursor.fetchall()
            return result if result is not None else []
        except pymysql.err.OperationalError as e:
            # 处理错误，可能通过重新连接并重试查询
            self.connect()
            # 您可以选择在此处重试查询，或只是引发错误以通知调用者
            raise e
        finally:
            cursor.close()
            if not self.conn.get_autocommit():
                self.conn.commit()  # 当在事务中时，确保每个查询的更改都被提交

#加载QSS文件
def load_stylesheet(self):
    try:
        with open("style.qss", "r", encoding='utf-8') as file:
            self.setStyleSheet(file.read())
    except Exception as e:
        print(f"Failed to load stylesheet: {e}")
if __name__ == '__main__':
    main()
