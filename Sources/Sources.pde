// Config
boolean utiliserVerlet = false; // true = Verlet ,  false = Euler

// Paramètres des collisions
final float SEUIL_REPOS = 40.0;
final float FRICTION_MUR = 4.0;
final float VITESSE_MAX = 400.0;

ArrayList<Particule> particules = new ArrayList<Particule>();
RegistreDeForces registreForces = new RegistreDeForces();
GenerateurGravite generateurGravite;
GenerateurFriction generateurFriction;
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

// Jeu
Particule blob;
GenerateurRessortAncreParticule generateurRessortAncreParticuleBlob;
ArrayList<Mur> murs = new ArrayList<Mur>();
int scorePanier = 0;
float panierX;
float panierY; 
float panierLargeur;
float panierHauteur;
int nombreDeParticules = 15; 

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

  blob = new Particule(new Vecteur3D(width/2, height/2, 0.0), 20, 20.0, 0.7, new Vecteur3D(), "Blob");
  generateurRessortAncreParticuleBlob = new GenerateurRessortAncreParticule(blob.position, 50.0, 100.0);
  
  sceneJeu();
  particules.add(blob);
  
}

void initialiserPanier() {

  Vecteur3D hautGauche  = new Vecteur3D(panierX - panierLargeur / 2, panierY, 0);
  Vecteur3D basGauche   = new Vecteur3D(panierX - panierLargeur / 2, panierY + panierHauteur, 0);
  Vecteur3D basDroite   = new Vecteur3D(panierX + panierLargeur / 2, panierY + panierHauteur, 0);
  Vecteur3D hautDroite  = new Vecteur3D(panierX + panierLargeur / 2, panierY, 0);

  float epaisseur = 6.0;

  murs.add(new Mur(hautGauche, basGauche, epaisseur)); 
  murs.add(new Mur(basGauche, basDroite, epaisseur)); 
  murs.add(new Mur(basDroite, hautDroite, epaisseur));
}

void sceneJeu() {
  panierHauteur = random(50, 100);
  panierLargeur = random(200, 300);
  panierX = random(0 + panierLargeur, width - panierLargeur);
  panierY = random(0 + panierHauteur, height - panierHauteur);

  murs.clear();
  particules.clear();
  registreForces.vider();
  generateursContact.clear();

  particules.add(blob);
  registreForces.ajouter(blob, generateurGravite);
  registreForces.ajouter(blob, generateurFriction);
  registreForces.ajouter(blob, generateurAmortissement);

  initialiserPanier();

  for (int i = 0; i < nombreDeParticules; i++) {
    float posX = random(100, width - 300);
    float posY = random(100, height - 200);
    
    Particule p = new Particule(new Vecteur3D(posX, posY, 0.0), 15, 20.0, 0.7, new Vecteur3D(), "P" + (i + 1));

    particules.add(p);

    registreForces.ajouter(p, generateurGravite);
    registreForces.ajouter(p, generateurAmortissement);
    registreForces.ajouter(p, generateurFriction);
  }

  int totalParticules = particules.size();
  int[] nbLiaisons = new int[totalParticules];
  boolean[][] liaisonsExistantes = new boolean[totalParticules][totalParticules];

  for (int i = 1; i < totalParticules; i++) {
    int cibleLiaisons = (int) random(0, 3); 
    int essais = 0;

    while (nbLiaisons[i] < cibleLiaisons && essais < 20) {
      essais++;
      int j = (int) random(1, totalParticules);

      if (i != j && !liaisonsExistantes[i][j] && nbLiaisons[j] < 2) {
        Particule p1 = particules.get(i);
        Particule p2 = particules.get(j);

        GenerateurRessortDeuxParticules ressort = new GenerateurRessortDeuxParticules(p2, 50.0f, 120.0);
        registreForces.ajouter(p1, ressort);

        liaisonsExistantes[i][j] = true;
        liaisonsExistantes[j][i] = true;
        nbLiaisons[i]++;
        nbLiaisons[j]++;
      }
    }
  }

  generateursContact.add(new GenerateurContactParticules(particules, 0.7));
  generateursContact.add(new GenerateurContactMursFenetre(particules, 0.0, width, 0.0, height, 0.5));
  generateursContact.add(new GenerateurContactMurs(particules, murs, 0.5));
}

void sceneExemples() {
  murs.clear();
  particules.clear();
  registreForces.vider();
  generateursContact.clear();

  // particule avec gravité ("G")
  particules.add(new Particule(new Vecteur3D(50.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D(), "G"));
  registreForces.ajouter(particules.get(0), generateurGravite);

  // particule avec ancre (ressort) + gravité + amortissement ("A")
  particules.add(new Particule(new Vecteur3D(100.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D(), "A"));
  generateurRessortAncreParticule = new GenerateurRessortAncreParticule(new Vecteur3D(100.0, 100.0, 0.0), 50.0, 100.0);
  registreForces.ajouter(particules.get(1), generateurGravite);
  registreForces.ajouter(particules.get(1), generateurAmortissement);
  registreForces.ajouter(particules.get(1), generateurRessortAncreParticule);

  // ressort entre deux particules + amortissement ("R1" et "R2")
  particules.add(new Particule(new Vecteur3D(150.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D(), "R1"));
  particules.add(new Particule(new Vecteur3D(300.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D(), "R2"));
  generateurRessortDeuxParticules = new GenerateurRessortDeuxParticules(particules.get(3), 50.0, 100.0);
  registreForces.ajouter(particules.get(2), generateurAmortissement);
  registreForces.ajouter(particules.get(3), generateurAmortissement);
  registreForces.ajouter(particules.get(2), generateurRessortDeuxParticules);

  // particule bungee + gravité + amortissement ("B")
  particules.add(new Particule(new Vecteur3D(400.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D(), "B"));
  generateurRessortBungee = new GenerateurRessortBungee(new Vecteur3D(400.0, 100.0, 0), 50.0, 100.0);
  registreForces.ajouter(particules.get(4), generateurAmortissement);
  registreForces.ajouter(particules.get(4), generateurGravite);
  registreForces.ajouter(particules.get(4), generateurRessortBungee);

  // démonstration de la gravité + friction ("F")
  particules.add(new Particule(new Vecteur3D(75.0, 100.0, 0.0), 20, 20.0, 0.99, new Vecteur3D(), "F"));
  registreForces.ajouter(particules.get(5), generateurGravite);
  registreForces.ajouter(particules.get(5), generateurFriction);

  // tige : deux particules gardent une distance fixe ("T1" et "T2")
  particules.add(new Particule(new Vecteur3D(600.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D(), "T1"));
  particules.add(new Particule(new Vecteur3D(660.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D(), "T2"));
  registreForces.ajouter(particules.get(6), generateurGravite);
  registreForces.ajouter(particules.get(7), generateurGravite);
  generateursContact.add(new GenerateurContactTige(particules.get(6), particules.get(7), 60.0));

  // câble : distance maximale entre deux particules ("C1" et "C2")
  particules.add(new Particule(new Vecteur3D(800.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D(-80.0, 0.0, 0.0), "C1"));
  particules.add(new Particule(new Vecteur3D(900.0, 100.0, 0.0), 20, 20.0, 0.7, new Vecteur3D(80.0, 0.0, 0.0), "C2"));
  registreForces.ajouter(particules.get(8), generateurGravite);
  registreForces.ajouter(particules.get(9), generateurGravite);
  generateursContact.add(new GenerateurContactCable(particules.get(8), particules.get(9), 120.0, 0.5));

  // interpénétrations et contacts au repos entre les particules
  generateursContact.add(new GenerateurContactParticules(particules, 0.7));
  // bords de la fenêtre
  generateursContact.add(new GenerateurContactMursFenetre(particules, 0.0, width, 0.0, height, 0.5));
}

// Game Loop
void draw() {
  calculerDeltaTemps();

  mettreAJourPhysique(dt);

  scorePanier = compterParticulesDansPanier();

  blob.position = new Vecteur3D(mouseX, mouseY, 0.0);
  generateurRessortAncreParticuleBlob.position_ancre = blob.position;

  for (int i = particules.size() - 1; i >= 0; i--) {
    Particule p = particules.get(i);
    if (p == blob) continue;

    if (p.position.x >= blob.position.x - blob.rayon - 20
      && p.position.x <= blob.position.x + blob.rayon + 20 &&
      p.position.y >= blob.position.y - blob.rayon - 20 &&
      p.position.y <= blob.position.y + blob.rayon + 20) {

      generateursContact.add(new GenerateurContactCable(p, blob, 200.0, 0.5));
      registreForces.ajouter(p, generateurRessortAncreParticuleBlob);
    }
  }

  dessiner();

  if (scorePanier == nombreDeParticules) {
    dessinerEcranVictoire();
  }
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
  if (key == 's' || key == 'S') {
    separerBlob();
  }
  if (key == 'r' || key == 'R') {
    sceneJeu();
  }
  if (key == 'e' || key == 'E') {
    sceneExemples();
  }
}

// Soparation des particules actuellement attachées au blob
void separerBlob() {
  for (Particule p : particules) {
    registreForces.retirer(p, generateurRessortAncreParticuleBlob);
  }

  ArrayList<GenerateurContact> generateurs = new ArrayList<GenerateurContact>();
  for (GenerateurContact g : generateursContact) {
    if (g instanceof GenerateurContactCable) {
      generateurs.add(g);
    }
  }

  for (GenerateurContact g : generateurs) {
    generateursContact.remove(g);
  }
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
  dessinerMurs();
  dessinerUI();
}

void dessinerMurs() {
  for (Mur mur : murs) {
    mur.draw();
  }
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
  text("dt : " + nf(dtAffiche * 1000, 0, 2) + " ms   |   FPS : " + nf(1.0/max(dtAffiche, 0.0001), 0, 1), 15, 75);
  text("Lacher les particules [S]", 15, 95);

  textSize(20);
  fill(240, 140, 40);
  text("Particules dans le panier : " + scorePanier + " / " + nombreDeParticules, 15, 15);
}

void dessinerEcranVictoire() {
  fill(10, 15, 25, 200);
  rect(0, 0, width, height);

  float largeurPanneau = 460;
  float hauteurPanneau = 280;
  float xPanneau = width / 2 - largeurPanneau / 2;
  float yPanneau = height / 2 - hauteurPanneau / 2;

  stroke(80, 220, 120); 
  strokeWeight(3);
  fill(25, 35, 50, 240);
  rect(xPanneau, yPanneau, largeurPanneau, hauteurPanneau, 15);

  textAlign(CENTER, CENTER);
  textSize(40);
  fill(80, 220, 120);
  text("VICTOIRE !", width / 2, yPanneau + 65);

  textSize(20);
  fill(230, 230, 240);
  text("Objectif atteint avec succès !", width / 2, yPanneau + 130);

  textSize(16);
  fill(240, 140, 40);
  text("Particules récoltées : " + scorePanier + " / " + nombreDeParticules, width / 2, yPanneau + 170);

  textSize(14);
  fill(160, 170, 190);
  text("Appuyez sur [R] pour rejouer", width / 2, yPanneau + 225);
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

int compterParticulesDansPanier() {
  int compteur = 0;

  float minX = panierX - panierLargeur / 2;
  float maxX = panierX + panierLargeur / 2;
  float minY = panierY;
  float maxY = panierY + panierHauteur;

  for (Particule p : particules) {
    if (p == blob) continue;

    if (p.position.x >= minX && p.position.x <= maxX &&
        p.position.y >= minY && p.position.y <= maxY) {
      compteur++;
    }
  }

  return compteur;
}