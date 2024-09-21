from .extensions import db, DateTime
from flask import current_app
import datetime


from enum import Enum
import jwt
import time
from werkzeug.security import generate_password_hash, check_password_hash
from .extensions import db


class Platforms(Enum):
    Facebook = 'Facebook'
    Instagram = 'Instagram'
    Website = 'Website'
    LinkedIn = 'LinkedIn'
    WhatsApp = 'WhatsApp'
    Contact = 'Contact'


class ContactItems(db.Model):
    __tablename__ = 'userContacts'
    id = db.Column(db.Integer, index=True)
    username = db.Column(db.String(32), primary_key=True)
    type = db.Column(db.Enum(Platforms), primary_key=True)
    link = db.Column(db.String(128), index=True)

    def serialize(self):
        return {
            'platform': self.type.value,
            'link': self.link
        }


class Follow(db.Model):
    __tablename__ = 'userFollow'
    following = db.Column(db.String(32), primary_key=True)
    follower = db.Column(db.String(32), primary_key=True)

    def serialize(self):
        follower_user = User.query.filter_by(username = self.following).first()
        return follower_user.serialize()


class Messages(db.Model):
    __tablename__ = 'userMessages'
    issuer = db.Column(db.String(32), primary_key=True)
    recipient = db.Column(db.String(32), primary_key=True)
    timestamp = db.Column(
        db.Integer, default=time.time_ns(), primary_key=True)
    body = db.Column(db.String(1024), primary_key=True)
    user_is_authenticated = db.Column(db.Boolean)

    def serialize(self): 
        return {
            'issuer': self.issuer,
            'recipient': self.recipient, 
            'timestamp': self.timestamp,
            'body':self.body
        }

    

class User(db.Model):
    __tablename__ = 'users'
    username = db.Column(db.String(32), primary_key=True)
    name = db.Column(db.String(32), index=True)
    surname = db.Column(db.String(32), index=True)
    fullname = db.Column(db.String(65), index=True)
    email = db.Column(db.String(32), index=True)
    phoneNumber = db.Column(db.String(32), index=True)
    companyName = db.Column(db.String(32), index=True, nullable=True)
    password_hash = db.Column(db.String(128))
    profile_picture = db.Column(db.String(128), nullable=True)
    role = db.Column(db.String(128))

    def serialize(self):
        return {
            'username': self.username,
            'name': self.name,
            'surname': self.surname,
            'company': self.companyName,
            'phoneNumber': self.phoneNumber, 
            'email':self.email,
            'role': self.role,
            'profile_picture': self.profile_picture
        }

    @staticmethod
    def verify_auth_token(token):
        try:
            # Decode the JWT token
            data = jwt.decode(
                token, current_app.config['SECRET_KEY'], algorithms=['HS256'])
        except jwt.ExpiredSignatureError:
            print("Token expired")  # Debugging output
            return None  # Token has expired
        except jwt.InvalidTokenError:
            print("Invalid token")  # Debugging output
            return None  # Invalid token

        # Look up the user based on the username in the token payload
        return User.query.filter_by(username=data['username']).first()

    def hash_password(self, password):
        self.password_hash = generate_password_hash(password)

    def verify_password(self, password):
        return check_password_hash(self.password_hash, password)

    def generate_auth_token(self, expires_in=600):
        return jwt.encode(
            {'username': self.username, 'exp': time.time() + expires_in},
            current_app.config['SECRET_KEY'], algorithm='HS256'
        )
