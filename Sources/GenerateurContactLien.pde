abstract class GenerateurContactLien implements GenerateurContact {

  Particule particule_a;
  Particule particule_b;

  GenerateurContactLien(Particule particule_a, Particule particule_b) {
    this.particule_a = particule_a;
    this.particule_b = particule_b;
  }

  void generer_contacts(ArrayList<Contact> contacts) {
  }

  float longueur_actuelle() {
    return particule_a.position.sub(particule_b.position).norme();
  }

  void dessiner() {
    stroke(255);
    line(particule_a.position.x, particule_a.position.y, particule_b.position.x, particule_b.position.y);
  }
}