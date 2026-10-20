// Registre qui sait quel générateur affecte quelle particule
class RegistreDeForces {

  class EnregistrementForce {
    Particule particule;
    GenerateurDeForce generateur;

    EnregistrementForce(Particule particule, GenerateurDeForce generateur) {
      this.particule = particule;
      this.generateur = generateur;
    }
  }

  ArrayList<EnregistrementForce> registre = new ArrayList<EnregistrementForce>();

  void ajouter(Particule particule, GenerateurDeForce generateur) {
    registre.add(new EnregistrementForce(particule, generateur));
  }

  void retirer(Particule particule, GenerateurDeForce generateur) {
    for (int i = registre.size() - 1; i >= 0; i--) {
      EnregistrementForce enregistrement = registre.get(i);
      if (enregistrement.particule == particule && enregistrement.generateur == generateur) {
        registre.remove(i);
      }
    }
  }

  void vider() {
    registre.clear();
  }

  void appliquer_forces(float duree) {
    for (EnregistrementForce enregistrement : registre) {
      enregistrement.generateur.appliquer_force(enregistrement.particule, duree);
    }
  }
}
