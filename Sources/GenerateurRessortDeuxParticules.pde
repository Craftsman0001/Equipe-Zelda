class GenerateurRessortDeuxParticules extends GenerateurRessort{

  Particule autre_particule;

  GenerateurRessortDeuxParticules(Particule autre_particule, float longueur_repos, float k) {
    super(longueur_repos, k);
    this.autre_particule = autre_particule;
  }

  void appliquer_force(Particule particule, float duree) {
    Vecteur3D force_ressort = new Vecteur3D(autre_particule.position);
    force_ressort = force_ressort.sub(particule.position);

    float stretch = force_ressort.norme() - longueur_repos;

    force_ressort.normaliser();
    force_ressort = force_ressort.mult(k * stretch);

    particule.ajouter_force(force_ressort);

    autre_particule.ajouter_force(force_ressort.mult(-1)); // D'après la 3e loi de Newton, la force exercée sur la deuxième particule est opposée à celle exercée sur la première
  }

  void dessiner(Particule p) {
    stroke(255);
    line(autre_particule.position.x, autre_particule.position.y, p.position.x, p.position.y);
  }
}
