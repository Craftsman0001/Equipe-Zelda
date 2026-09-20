Particule p;
ArrayList<Particule> particules = new ArrayList<Particule>();;

void setup() {
  size(800, 600);

  p = new Particule(width/2, height/2, 0, 20, 10);
  p.velocite = new Vecteur3D(150, 0, 0);

  particules.add(p);
}

void draw() {
  background(255);

  mettreAJourPhysique();

  for (Particule particule : particules) {
    particule.draw();
  }

}

void mettreAJourPhysique() {
  float dt = 1.0 / frameRate;
  for (Particule particule : particules) {
    particule.integrer_euler(dt);
  }
}
