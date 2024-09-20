from flask import Flask
from .extensions import db, basic_auth, token_auth
from .config import Config
from .auth import auth_bp
from .contact_cards import contacts_bp
from .user import user_bp
from .site import site_bp
from .messages import messages_bp


def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)

    app.register_blueprint(auth_bp, url_prefix='/api')
    app.register_blueprint(contacts_bp, url_prefix='/api')
    app.register_blueprint(user_bp, url_prefix='/api')
    app.register_blueprint(site_bp)
    app.register_blueprint(messages_bp, url_prefix='/api')

    return app
