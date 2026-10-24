class GenerateurContactMurs implements GenerateurContact {

  ArrayList<Particule> particules;
  float restitution;
  float gauche, droite, haut, bas;

  GenerateurContactMurs(ArrayList<Particule> particules, float gauche, float droite, float haut, float bas, float restitution) {
    this.particules = particules;
    this.gauche = gauche;
    this.droite = droite;
    this.haut = haut;
    this.bas = bas;
    this.restitution = restitution;
  }

  // Détecte les collisions avec les bords de la fenêtre
  void generer_contacts(ArrayList<Contact> contacts) {
    for (Particule p : particules) {
      float r = rayon_physique(p);

      if (p.position.x - r < gauche) {
        contacts.add(new Contact(p, null, new Vecteur3D(1.0, 0.0, 0.0), gauche - (p.position.x - r), restitution));
      }
      if (p.position.x + r > droite) {
        contacts.add(new Contact(p, null, new Vecteur3D(-1.0, 0.0, 0.0), (p.position.x + r) - droite, restitution));
      }
      if (p.position.y - r < haut) {
        contacts.add(new Contact(p, null, new Vecteur3D(0.0, 1.0, 0.0), haut - (p.position.y - r), restitution));
      }
      if (p.position.y + r > bas) {
        contacts.add(new Contact(p, null, new Vecteur3D(0.0, -1.0, 0.0), (p.position.y + r) - bas, restitution));
      }
    }
  }
}