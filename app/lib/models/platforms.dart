import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Platforms {
  Facebook(icon: FontAwesomeIcons.facebook, name: 'Facebook'),
  LinkedIn(icon: FontAwesomeIcons.linkedin, name: 'LinkedIn'),
  WhatsApp(icon: FontAwesomeIcons.whatsapp, name: 'WhatsApp'),
  Website(icon: FontAwesomeIcons.globe, name: 'Website'),
  Contacts(icon: FontAwesomeIcons.addressBook, name: 'Contact'),
  Instagram(icon: FontAwesomeIcons.instagram, name: 'Instagram');

  const Platforms({required this.icon, required this.name});

  final IconData icon;
  final String name;
}