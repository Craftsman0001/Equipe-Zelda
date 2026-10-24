class GenerateurContactParticules implements GenerateurContact {

  ArrayList<Particule> particules;
  float restitution;

  GenerateurContactParticules(ArrayList<Particule> particules, float restitution) {
    this.particules = particules;
    this.restitution = restitution;
  }

  // Détecte les interpénétrations cercle contre cercle
  void generer_contacts(ArrayList<Contact> contacts) {
    for (int i = 0; i < particules.size(); i++) {
      Particule a = particules.get(i);

      for (int j = i + 1; j < particules.size(); j++) {
        Particule b = particules.get(j);

        if (a.get_inverse_masse() == 0 && b.get_inverse_masse() == 0) continue;

        Vecteur3D difference = a.position.sub(b.position);
        float distance_carree = difference.norme_carree();
        float somme_rayons = rayon_physique(a) + rayon_physique(b);

        if (distance_carree >= somme_rayons * somme_rayons) continue;

        float distance = sqrt(distance_carree);
        Vecteur3D normale;

        if (distance == 0) {
          normale = new Vecteur3D(0.0, -1.0, 0.0);
        } else {
          normale = difference.mult(1.0 / distance);
        }

        contacts.add(new Contact(a, b, normale, somme_rayons - distance, restitution));
      }
    }
  }
}