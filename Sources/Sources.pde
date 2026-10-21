
// Config


boolean utiliserVerlet = false; // true = Verlet ,  false = Euler

ArrayList<Particule> projectilesActifs = new ArrayList<Particule>();

// Gestion du temps
int dernierTempsMillis;
float dt;
float dtAffiche;

void setup() {
  size(1000, 600);

  // On effectue les tests avant d'exécuter le jeu
  TestVecteur3D test = new TestVecteur3D();
  test.executerTests(); 

  dernierTempsMillis = millis();
  textAlign(LEFT, TOP);
}

// Game Loop
void draw() {
  calculerDeltaTemps();

  mettreAJourPhysique(dt);
  
  dessiner();
}

// On calcul le temps de la frame
void calculerDeltaTemps() {
  int mtn = millis();
  dt = (mtn - dernierTempsMillis) / 1000.0;
  dernierTempsMillis = mtn;
  dt = constrain(dt, 0, 0.05);
  dtAffiche = lerp(dtAffiche, dt, 0.1);
}

// Inputs
void keyPressed() {

}

void mousePressed() {
  projectilesActifs.add(new Particule(
    new Vecteur3D(mouseX, mouseY, 0.0),
    20,
    20.0,
    0.99,
    new Vecteur3D()
  ));
}


// Physique de la particule mis à jour avec les intégrateurs 
void mettreAJourPhysique(float dtLocal) {
  for (int i = projectilesActifs.size() - 1; i >= 0; i--) {
    Particule p = projectilesActifs.get(i);

    if (utiliserVerlet) {
      p.integrer_verlet(dtLocal);
    } else {
      p.integrer_euler(dtLocal);
    }
  }
}


// Fonction générale appelé depuis la game loop
void dessiner() {
  background(18, 22, 38);
  dessinerProjectiles();
  dessinerUI();
}


void dessinerProjectiles() {
  for (Particule p : projectilesActifs) {
    p.draw();
  }
}

void dessinerUI() {
  fill(255);
  textSize(14);
  text("Intégrateur [V] : " + (utiliserVerlet ? "Verlet" : "Euler"), 15, 55);
  text("dt : " + nf(dtAffiche * 1000, 0, 2) + " ms   |   FPS : " + nf(1.0/max(dtAffiche,0.0001), 0, 1), 15, 75);
}