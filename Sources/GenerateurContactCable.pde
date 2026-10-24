class GenerateurContactCable extends GenerateurContactLien {

  float longueur_max;
  float restitution;

  GenerateurContactCable(Particule particule_a, Particule particule_b, float longueur_max, float restitution) {
    super(particule_a, particule_b);
    this.longueur_max = longueur_max;
    this.restitution = restitution;
  }

  // Limite la distance maximale entre les deux particules
  void generer_contacts(ArrayList<Contact> contacts) {
    float longueur_courante = longueur_actuelle();

    if (longueur_courante < longueur_max) return;

    Vecteur3D normale = particule_b.position.sub(particule_a.position);
    normale.normaliser();

    contacts.add(new Contact(particule_a, particule_b, normale, longueur_courante - longueur_max, restitution));
  }
}