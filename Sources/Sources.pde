
// Config
boolean utiliserVerlet = false; // true = Verlet ,  false = Euler

ArrayList<Particule> particules = new ArrayList<Particule>();
RegistreDeForces registreForces = new RegistreDeForces();
GenerateurGravite generateurGravite;
GenerateurFriction generateurFriction;
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
  generateurFriction = new GenerateurFriction(0.5, 0.02);
  
  // particule avec gravité ("G")
  particules.add(new Particule(new Vecteur3D(50.0, 100.0, 0.0), 20, 20.0, 0.99, new Vecteur3D(), "G"));
  registreForces.ajouter(particules.get(0), generateurGravite);
  
  // particule avec ancre (ressort) + gravité + amortissement ("A")
  particules.add(new Particule(new Vecteur3D(100.0, 100.0, 0.0), 20, 20.0, 0.99, new Vecteur3D(), "A"));
  generateurRessortAncreParticule = new GenerateurRessortAncreParticule(new Vecteur3D(100.0, 100.0, 0.0), 50.0, 100.0);
  registreForces.ajouter(particules.get(1), generateurGravite);
  registreForces.ajouter(particules.get(1), generateurAmortissement);
  registreForces.ajouter(particules.get(1), generateurRessortAncreParticule);

   // ressort entre deux particules + amortissement ("R1" et "R2")
  particules.add(new Particule(new Vecteur3D(150.0, 100.0, 0.0), 20, 20.0, 0.99, new Vecteur3D(), "R1"));
  particules.add(new Particule(new Vecteur3D(300.0, 100.0, 0.0), 20, 20.0, 0.99, new Vecteur3D(), "R2"));
  generateurRessortDeuxParticules = new GenerateurRessortDeuxParticules(particules.get(3), 50.0, 100.0);
  registreForces.ajouter(particules.get(2), generateurAmortissement);
  registreForces.ajouter(particules.get(3), generateurAmortissement);
  registreForces.ajouter(particules.get(2), generateurRessortDeuxParticules);

  // particule bungee + gravité + amortissement ("B")
  particules.add(new Particule(new Vecteur3D(400.0, 100.0, 0.0), 20, 20.0, 0.99, new Vecteur3D(), "B"));
  generateurRessortBungee = new GenerateurRessortBungee(new Vecteur3D(400.0, 100.0, 0), 50.0, 100.0);
  registreForces.ajouter(particules.get(4), generateurAmortissement);
  registreForces.ajouter(particules.get(4), generateurGravite);
  registreForces.ajouter(particules.get(4), generateurRessortBungee);

  // démonstration de la gravité + friction ("F")
  particules.add(new Particule(new Vecteur3D(75.0, 100.0, 0.0), 20, 20.0, 0.99, new Vecteur3D(), "F"));
  registreForces.ajouter(particules.get(5), generateurGravite);
  registreForces.ajouter(particules.get(5), generateurFriction);
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
  if (key == 'v' || key == 'V') {
    utiliserVerlet = !utiliserVerlet;
  }
}

void mousePressed() {
  Particule p0 = particules.get(0);
  p0.position = new Vecteur3D(mouseX, mouseY, 0);
  p0.velocite = new Vecteur3D(0, 0, 0);
  p0.position_precedente = null;

  particules.get(5).position = new Vecteur3D(mouseX + 30, mouseY, 0.0);
  particules.get(5).velocite = new Vecteur3D();
  particules.get(5).position_precedente = null;
}


// Physique de la particule mis à jour avec les intégrateurs 
void mettreAJourPhysique(float dtLocal) {
  for (int i = particules.size() - 1; i >= 0; i--) {
    Particule p = particules.get(i);
     p.vider_accumulateur();
  }

  registreForces.appliquer_forces(dtLocal);

  for (int i = particules.size() - 1; i >= 0; i--) {
    Particule p = particules.get(i);
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
  for (Particule p : particules) {
    p.draw();
  }
}

void dessinerUI() {
  fill(255);
  textAlign(LEFT, TOP);
  textSize(14);
  text("Intégrateur [V] : " + (utiliserVerlet ? "Verlet" : "Euler"), 15, 55);
  text("dt : " + nf(dtAffiche * 1000, 0, 2) + " ms   |   FPS : " + nf(1.0/max(dtAffiche,0.0001), 0, 1), 15, 75);
}

void dessinerForces() {
  registreForces.afficher_ressorts();
}