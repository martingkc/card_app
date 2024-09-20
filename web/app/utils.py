from flask import current_app
from .models import User, ContactItems
from .extensions import hashlib


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in current_app.config['ALLOWED_EXTENSIONS']


def create_vcf(user):
    path = current_app.config['CONTACT_FOLDER'] + "/" + f"{user.username}.vcf"
    f = open(path, "w")
    f.write(f"BEGIN:VCARD\n" +
            "VERSION:2.1\n" +
            f"N:{user.name};{user.surname};;\n" +
            f"FN:{user.name};{user.surname}\n" +
            f"ORG:{user.companyName}\n" +
            f"TITLE:{user.role}\n" +
            f"PHOTO;GIF:http://www.example.com/dir_photos/my_photo.gif\n" +
            f"TEL;WORK;VOICE:{user.phoneNumber}\n" +
            f"EMAIL:{user.email}\n" +
            "REV:20080424T195243Z\n" +
            "END:VCARD")
    f.close()
