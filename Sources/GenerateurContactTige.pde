class GenerateurContactTige extends GenerateurContactLien {

  float longueur;

  GenerateurContactTige(Particule particule_a, Particule particule_b, float longueur) {
    super(particule_a, particule_b);
    this.longueur = longueur;
  }

  // Maintient une distance fixe (trop longue ou trop courte)
  void generer_contacts(ArrayList<Contact> contacts) {
    float longueur_courante = longueur_actuelle();
    if (longueur_courante == longueur) return;

    Vecteur3D normale = particule_b.position.sub(particule_a.position);
    normale.normaliser();

    if (longueur_courante > longueur) {
      contacts.add(new Contact(particule_a, particule_b, normale, longueur_courante - longueur, 0.0));
    } else {
      contacts.add(new Contact(particule_a, particule_b, normale.mult(-1.0), longueur - longueur_courante, 0.0));
    }
  }
}