Particule p;
ArrayList<Particule> particules = new ArrayList<Particule>();

void setup() {
  size(800, 600);

  TestVecteur3D tests = new TestVecteur3D();
  tests.executerTests();

  p = new Particule(new Vecteur3D(width/2, height/2, 0), 20, 10, 0.80, new Vecteur3D(150, 0, 0));
  particules.add(p);
}

void draw() {
  // Calculs
  mettre_a_jour_logique();

  // Dessin
  dessiner_jeu();
}

void mettre_a_jour_logique() {
  float dt = 1.0 / frameRate;

  // Physique
  for (Particule particule : particules) {
    particule.integrer_euler(dt);
  }

  // Collisions
  // Suppressions
}

void dessiner_jeu() {
  background(255);

  // Dessin des entités
  for (Particule particule : particules) {
    particule.draw();
  }

  // Afficher le texte du GUI
}
