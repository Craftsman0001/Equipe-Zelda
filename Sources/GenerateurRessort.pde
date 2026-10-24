abstract class GenerateurRessort implements GenerateurDeForce {

  float longueur_repos = 50.0;
  float k = 100.0;

  GenerateurRessort(float longueur_repos, float k) {
    this.longueur_repos = longueur_repos;
    this.k = k;
  }

  void appliquer_force(Particule particule, float duree) {
  }

  void dessiner(Particule p) {
    
  }
}
