
// Config
boolean utiliserVerlet = false; // true = Verlet ,  false = Euler

// Paramètres des collisions
final float SEUIL_REPOS = 40.0;
final float FRICTION_MUR = 4.0;
final float VITESSE_MAX = 400.0;

ArrayList<Particule> paricules = new ArrayList<Particule>();
RegistreDeForces registreForces = new RegistreDeForces();
GenerateurGravite generateurGravite;
GenerateurRessortAncreParticule generateurRessortAncreParticule;
GenerateurAmortissement generateurAmortissement;
GenerateurRessortDeuxParticules generateurRessortDeuxParticules;
GenerateurRessortBungee generateurRessortBungee;

// Collisions
ArrayList<Contact> contacts = new ArrayList<Contact>();
ArrayList<GenerateurContact> generateursContact = new ArrayList<GenerateurContact>();
ResolveurContacts resolveurContacts = new ResolveurContacts(20, 20);

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
  paricules.add(new Particule(new Vecteur3D(50.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D()));
  registreForces.ajouter(paricules.get(0), generateurGravite);
  
  // particule avec ancre (ressort) + gravité + amortissement
  paricules.add(new Particule(new Vecteur3D(100.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D()));
  generateurRessortAncreParticule = new GenerateurRessortAncreParticule(new Vecteur3D(100.0, 100.0, 0.0), 50.0, 100.0);
  registreForces.ajouter(paricules.get(1), generateurGravite);
  registreForces.ajouter(paricules.get(1), generateurAmortissement);
  registreForces.ajouter(paricules.get(1), generateurRessortAncreParticule);

  // ressort entre deux particules + amortissement
  paricules.add(new Particule(new Vecteur3D(150.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D()));
  paricules.add(new Particule(new Vecteur3D(300.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D()));
  generateurRessortDeuxParticules = new GenerateurRessortDeuxParticules(paricules.get(3), 50.0, 100.0);
  registreForces.ajouter(paricules.get(2), generateurAmortissement);
  registreForces.ajouter(paricules.get(3), generateurAmortissement);
  registreForces.ajouter(paricules.get(2), generateurRessortDeuxParticules);

  // particule bungee + gravité + amortissement
  paricules.add(new Particule(new Vecteur3D(400.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D()));
  generateurRessortBungee = new GenerateurRessortBungee(new Vecteur3D(400.0, 100.0, 0), 50.0, 100.0);
  registreForces.ajouter(paricules.get(4), generateurAmortissement);
  registreForces.ajouter(paricules.get(4), generateurGravite);
  registreForces.ajouter(paricules.get(4), generateurRessortBungee);

  // tige : deux particules gardent une distance fixe
  paricules.add(new Particule(new Vecteur3D(600.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D()));
  paricules.add(new Particule(new Vecteur3D(660.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D()));
  registreForces.ajouter(paricules.get(5), generateurGravite);
  registreForces.ajouter(paricules.get(6), generateurGravite);
  generateursContact.add(new GenerateurContactTige(paricules.get(5), paricules.get(6), 60.0));

  // câble : distance maximale entre deux particules
  paricules.add(new Particule(new Vecteur3D(800.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D(-80.0, 0.0, 0.0)));
  paricules.add(new Particule(new Vecteur3D(900.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D(80.0, 0.0, 0.0)));
  registreForces.ajouter(paricules.get(7), generateurGravite);
  registreForces.ajouter(paricules.get(8), generateurGravite);
  generateursContact.add(new GenerateurContactCable(paricules.get(7), paricules.get(8), 120.0, 0.5));

  // interpénétrations et contacts au repos entre les particules
  generateursContact.add(new GenerateurContactParticules(paricules, 0.7));
  // bords de la fenêtre
  generateursContact.add(new GenerateurContactMurs(paricules, 0.0, width, 0.0, height, 0.5));
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
  paricules.get(0).velocite = new Vecteur3D();
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

  // Détection des collisions puis résolution par impulsions
  contacts.clear();
  for (GenerateurContact g : generateursContact) {
    g.generer_contacts(contacts);
  }
  resolveurContacts.resoudre(contacts, dtLocal);
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

  // Tiges et câbles
  for (GenerateurContact g : generateursContact) {
    if (g instanceof GenerateurContactLien) {
      ((GenerateurContactLien) g).dessiner();
    }
  }
}