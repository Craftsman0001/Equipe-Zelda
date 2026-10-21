
// Config
boolean utiliserVerlet = false; // true = Verlet ,  false = Euler

ArrayList<Particule> paricules = new ArrayList<Particule>();
RegistreDeForces registreForces = new RegistreDeForces();
GenerateurGravite generateurGravite;
GenerateurRessortAncreParticule generateurRessortAncreParticule;
GenerateurAmortissement generateurAmortissement;
GenerateurRessortDeuxParticules generateurRessortDeuxParticules;
GenerateurRessortBungee generateurRessortBungee;

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

  generateurAmortissement = new GenerateurAmortissement(20.0);
  generateurGravite = new GenerateurGravite(new Vecteur3D(0.0, 200.0, 0.0));
  
  // particule avec gravité
  paricules.add(new Particule(new Vecteur3D(50.0, 100.0, 0.0), 20, 20.0, 0.99, new Vecteur3D()));
  registreForces.ajouter(paricules.get(0), generateurGravite);
  
  // particule avec ancre (ressort) + gravité + amortissement
  paricules.add(new Particule(new Vecteur3D(100.0, 100.0, 0.0), 20, 20.0, 0.99, new Vecteur3D()));
  generateurRessortAncreParticule = new GenerateurRessortAncreParticule(new Vecteur3D(100.0, 100.0, 0.0), 50.0, 100.0);
  registreForces.ajouter(paricules.get(1), generateurGravite);
  registreForces.ajouter(paricules.get(1), generateurAmortissement);
  registreForces.ajouter(paricules.get(1), generateurRessortAncreParticule);

   // ressort entre deux particules + amortissement
  paricules.add(new Particule(new Vecteur3D(150.0, 100.0, 0.0), 20, 20.0, 0.99, new Vecteur3D()));
  paricules.add(new Particule(new Vecteur3D(300.0, 100.0, 0.0), 20, 20.0, 0.99, new Vecteur3D()));
  generateurRessortDeuxParticules = new GenerateurRessortDeuxParticules(paricules.get(3), 50.0, 100.0);
  registreForces.ajouter(paricules.get(2), generateurAmortissement);
  registreForces.ajouter(paricules.get(3), generateurAmortissement);
  registreForces.ajouter(paricules.get(2), generateurRessortDeuxParticules);

  // particule bungee + gravité + amortissement
  paricules.add(new Particule(new Vecteur3D(400.0, 100.0, 0.0), 20, 20.0, 0.99, new Vecteur3D()));
  generateurRessortBungee = new GenerateurRessortBungee(new Vecteur3D(400.0, 100.0, 0), 50.0, 100.0);
  registreForces.ajouter(paricules.get(4), generateurAmortissement);
  registreForces.ajouter(paricules.get(4), generateurGravite);
  registreForces.ajouter(paricules.get(4), generateurRessortBungee);
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
  paricules.get(0).position = new Vecteur3D(mouseX, mouseY, 0.0);
}


// Physique de la particule mis à jour avec les intégrateurs 
void mettreAJourPhysique(float dtLocal) {
  for (int i = paricules.size() - 1; i >= 0; i--) {
    Particule p = paricules.get(i);
     p.vider_accumulateur();
  }

  registreForces.appliquer_forces(dtLocal);

  for (int i = paricules.size() - 1; i >= 0; i--) {
    Particule p = paricules.get(i);
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
  dessinerForces();
  dessinerParticules();
  dessinerUI();
}


void dessinerParticules() {
  for (Particule p : paricules) {
    p.draw();
  }
}

void dessinerUI() {
  fill(255);
  textSize(14);
  text("Intégrateur [V] : " + (utiliserVerlet ? "Verlet" : "Euler"), 15, 55);
  text("dt : " + nf(dtAffiche * 1000, 0, 2) + " ms   |   FPS : " + nf(1.0/max(dtAffiche,0.0001), 0, 1), 15, 75);
}

void dessinerForces() {
  registreForces.afficher_ressorts();
}