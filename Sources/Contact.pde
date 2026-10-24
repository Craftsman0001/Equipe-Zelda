// Rayon physique (draw() utilise circle(), donc rayon est un diamètre)
float rayon_physique(Particule p) {
  return p.rayon / 2.0;
}

class Contact {

  Particule particule_a;
  Particule particule_b;
  Vecteur3D normale;
  float penetration;
  float restitution;

  Vecteur3D deplacement_a = new Vecteur3D();
  Vecteur3D deplacement_b = new Vecteur3D();

  Contact(Particule particule_a, Particule particule_b, Vecteur3D normale, float penetration, float restitution) {
    this.particule_a = particule_a;
    this.particule_b = particule_b;
    this.normale = normale;
    this.penetration = penetration;
    this.restitution = restitution;
  }

  // Somme des inverses de masse des particules impliquées
  float inverse_masse_totale() {
    float total = particule_a.get_inverse_masse();
    if (particule_b != null) {
      total += particule_b.get_inverse_masse();
    }
    return total;
  }

  // Vitesse de séparation le long de la normale (négative = rapprochement)
  float calculer_vitesse_separation() {
    Vecteur3D vitesse_relative = new Vecteur3D(particule_a.velocite);
    if (particule_b != null) {
      vitesse_relative = vitesse_relative.sub(particule_b.velocite);
    }
    return vitesse_relative.produit_scalaire(normale);
  }

  // Résolution des vitesses par impulsion
  void resoudre_velocite(float duree) {
    float vitesse_separation = calculer_vitesse_separation();

    if (vitesse_separation > 0) return;

    float inverse_masse_totale = inverse_masse_totale();
    if (inverse_masse_totale <= 0) return;

    float restitution_effective = restitution;
    if (-vitesse_separation < SEUIL_REPOS) restitution_effective = 0.0;

    float nouvelle_vitesse_separation = -vitesse_separation * restitution_effective;

    Vecteur3D acceleration_relative = new Vecteur3D(particule_a.acceleration);
    if (particule_b != null) {
      acceleration_relative = acceleration_relative.sub(particule_b.acceleration);
    }
    float vitesse_separation_acceleration = acceleration_relative.produit_scalaire(normale) * duree;

    if (vitesse_separation_acceleration < 0) {
      nouvelle_vitesse_separation += restitution_effective * vitesse_separation_acceleration;
      if (nouvelle_vitesse_separation < 0) {
        nouvelle_vitesse_separation = 0;
      }
    }

    float delta_vitesse = nouvelle_vitesse_separation - vitesse_separation;

    float impulsion = delta_vitesse / inverse_masse_totale;
    Vecteur3D impulsion_vecteur = normale.mult(impulsion);

    particule_a.velocite = particule_a.velocite.add(impulsion_vecteur.mult(particule_a.get_inverse_masse()));
    if (particule_b != null) {
      particule_b.velocite = particule_b.velocite.add(impulsion_vecteur.mult(-particule_b.get_inverse_masse()));
    }
  }

  // Friction contre un objet immobile (mur, sol)
  void appliquer_friction(float duree) {
    if (particule_b != null) return;

    Vecteur3D v = particule_a.velocite;
    float v_normale = v.produit_scalaire(normale);
    Vecteur3D v_tangente = v.sub(normale.mult(v_normale));

    float facteur = min(1.0, FRICTION_MUR * duree);
    particule_a.velocite = v.sub(v_tangente.mult(facteur));
  }

  // Résolution de l'interpénétration selon les inverses de masse
  void resoudre_interpenetration() {
    deplacement_a = new Vecteur3D();
    deplacement_b = new Vecteur3D();

    if (penetration <= 0) return;

    float inverse_masse_totale = inverse_masse_totale();
    if (inverse_masse_totale <= 0) return;

    Vecteur3D deplacement_par_inverse_masse = normale.mult(penetration / inverse_masse_totale);

    deplacement_a = deplacement_par_inverse_masse.mult(particule_a.get_inverse_masse());
    particule_a.position = particule_a.position.add(deplacement_a);

    if (particule_b != null) {
      deplacement_b = deplacement_par_inverse_masse.mult(-particule_b.get_inverse_masse());
      particule_b.position = particule_b.position.add(deplacement_b);
    }
  }
}