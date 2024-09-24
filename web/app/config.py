import os

class Config:
    SECRET_KEY = 'the quick brown fox jumps over the lazy dog'
    SQLALCHEMY_DATABASE_URI = 'sqlite:///db.sqlite'
    SQLALCHEMY_COMMIT_ON_TEARDOWN = True
    UPLOAD_FOLDER = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'Downloads'))
    CONTACT_FOLDER = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'Contacts'))

    ALLOWED_EXTENSIONS = {'xls', 'csv', 'png', 'jpeg', 'jpg'}
    MAX_CONTENT_LENGTH = 500 * 1000 * 1000  # 500 MB
    DOMAIN = 'http://15.237.248.215/'
