class GenerateurContactMurs implements GenerateurContact {

 ArrayList<Particule> particules;
  ArrayList<Mur> murs;
  float restitution;

  GenerateurContactMurs(ArrayList<Particule> particules, ArrayList<Mur> murs, float restitution) {
    this.particules = particules;
    this.murs = murs;
    this.restitution = restitution;
  }

  void generer_contacts(ArrayList<Contact> contacts) {
    for (Particule p : particules) {
      float r = rayon_physique(p);

      for (Mur mur : murs) {
        Vecteur3D AB = mur.getVecteurDirecteur();
        Vecteur3D AP = p.position.sub(mur.p1);

        float ab2 = AB.norme_carree();
        if (ab2 == 0) continue;

        float t = AP.produit_scalaire(AB) / ab2;
        t = constrain(t, 0.0, 1.0);
        // si t == 1, le plus proche est m.p2
        // si t == 0, le plus proche est m.p1

        Vecteur3D pointProche = mur.p1.add(AB.mult(t));
        Vecteur3D diff = p.position.sub(pointProche);
        float distCarree = diff.norme_carree();

        if (distCarree < r * r && distCarree > 0) {
          float dist = sqrt(distCarree);
          Vecteur3D normale = diff.mult(1.0 / dist);
          float penetration = r - dist;

          contacts.add(new Contact(p, null, normale, penetration, restitution));
        }
      }
    }
  }
}