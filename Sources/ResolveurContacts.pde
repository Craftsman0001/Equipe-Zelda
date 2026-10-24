class ResolveurContacts {

  int iterations_velocite;
  int iterations_position;

  ResolveurContacts(int iterations_velocite, int iterations_position) {
    this.iterations_velocite = iterations_velocite;
    this.iterations_position = iterations_position;
  }

  void resoudre(ArrayList<Contact> contacts, float duree) {
    if (contacts.isEmpty()) return;

    ajuster_vitesses(contacts, duree);

    for (Contact c : contacts) {
      c.appliquer_friction(duree);
    }

    ajuster_positions(contacts);
  }

  // Résout d'abord le contact qui se rapproche le plus vite
  void ajuster_vitesses(ArrayList<Contact> contacts, float duree) {
    for (int iteration = 0; iteration < iterations_velocite; iteration++) {
      float pire = Float.MAX_VALUE;
      Contact choisi = null;

      for (Contact c : contacts) {
        float vitesse_separation = c.calculer_vitesse_separation();
        if (vitesse_separation < pire && (vitesse_separation < 0 || c.penetration > 0)) {
          pire = vitesse_separation;
          choisi = c;
        }
      }

      if (choisi == null) break;

      choisi.resoudre_velocite(duree);
    }
  }

  // Résout d'abord l'interpénétration la plus profonde, puis met à jour les autres contacts
  void ajuster_positions(ArrayList<Contact> contacts) {
    for (int iteration = 0; iteration < iterations_position; iteration++) {
      float max_penetration = 0.0;
      Contact choisi = null;

      for (Contact c : contacts) {
        if (c.penetration > max_penetration) {
          max_penetration = c.penetration;
          choisi = c;
        }
      }

      if (choisi == null) break;

      choisi.resoudre_interpenetration();
      choisi.penetration = 0.0;

      for (Contact c : contacts) {
        if (c == choisi) continue;

        if (c.particule_a == choisi.particule_a) {
          c.penetration -= choisi.deplacement_a.produit_scalaire(c.normale);
        } else if (c.particule_a == choisi.particule_b) {
          c.penetration -= choisi.deplacement_b.produit_scalaire(c.normale);
        }

        if (c.particule_b != null) {
          if (c.particule_b == choisi.particule_a) {
            c.penetration += choisi.deplacement_a.produit_scalaire(c.normale);
          } else if (c.particule_b == choisi.particule_b) {
            c.penetration += choisi.deplacement_b.produit_scalaire(c.normale);
          }
        }
      }
    }
  }
}