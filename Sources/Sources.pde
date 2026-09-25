
// Config
final int TYPE_BALLE = 0, TYPE_BOULET = 1, TYPE_LASER = 2, TYPE_BOULE_FEU = 3;
int typeProjectileCourant = TYPE_BALLE;

String[] nomsProjectiles   = {"Balle", "Boulet", "Laser", "Boule de feu"};
float[]  massesProjectiles = {0.2,     5.0,      0.05,    1.0};   // kg
float[]  vitessesInit      = {650,     280,      1300,    420};   // px/s
color[]  couleursProj      = {color(255,255,0), color(140,140,140), color(255,40,40), color(255,120,0)};
int[]    taillesProj       = {8,       20,       6,       16};    // rayon en px
float    dampingCommun     = 0.999;


boolean utiliserVerlet = false; // true = Verlet ,  false = Euler

ArrayList<Particule> projectilesActifs = new ArrayList<Particule>();
ArrayList<ArrayList<PVector>> trajectoires = new ArrayList<ArrayList<PVector>>();

float angleCanon = 45; // degrés
Vecteur3D positionCanon;

// Gestion du temps
int dernierTempsMillis;
float dt;
float dtAffiche;

// State du jeu
final int ETAT_EN_COURS = 0, ETAT_VICTOIRE = 1, ETAT_DEFAITE = 2;
int etatJeu = ETAT_EN_COURS;

final int NB_TIRS_MAX = 15;      // nombre de tirs par partie
final int SCORE_VICTOIRE = 5;    // nombre de cibles à toucher pour gagner

int tirsRestants;
int score;

Vecteur3D positionCible;
float rayonCible = 30;

// zone où la cible peut apparaître verticalement
float margeHautCible = 60;       
float margeBasCible = 260;

void setup() {
  size(1000, 600);

  // On effectue les tests avant d'exécuter le jeu
  TestVecteur3D test = new TestVecteur3D();
  test.executerTests(); 

  positionCanon = new Vecteur3D(60, height - 40, 0);
  dernierTempsMillis = millis();
  textAlign(LEFT, TOP);
  reinitialiserPartie();
}

// Game Loop
void draw() {
  calculerDeltaTemps();
  gererEntreesContinues();
  if (etatJeu == ETAT_EN_COURS) {
    mettreAJourPhysique(dt);
  }
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
void gererEntreesContinues() {
  float dx = mouseX - positionCanon.x;
  float dy = positionCanon.y - mouseY;
  float angle = degrees(atan2(dy, dx));
  angleCanon = constrain(angle, 5, 85);
}

void keyPressed() {
  if (key == '1') typeProjectileCourant = TYPE_BALLE;
  if (key == '2') typeProjectileCourant = TYPE_BOULET;
  if (key == '3') typeProjectileCourant = TYPE_LASER;
  if (key == '4') typeProjectileCourant = TYPE_BOULE_FEU;
  if (key == 'v' || key == 'V') utiliserVerlet = !utiliserVerlet;
  if (key == 'r' || key == 'R') reinitialiserPartie();
}

void mousePressed() {
  tirer();
}


// On lance le projectile en appliquant la v0 de la particule et la gravité
void tirer() {
  if (etatJeu != ETAT_EN_COURS || tirsRestants <= 0) return;

  float vitesseNorme = vitessesInit[typeProjectileCourant];
  float masse = massesProjectiles[typeProjectileCourant];

  float rad = radians(angleCanon);
  Vecteur3D vitesseInitiale = new Vecteur3D(cos(rad) * vitesseNorme, -sin(rad) * vitesseNorme, 0);
  Vecteur3D positionDepart  = new Vecteur3D(positionCanon.x, positionCanon.y, positionCanon.z);

  Particule p = new Particule(positionDepart, taillesProj[typeProjectileCourant], masse, dampingCommun, vitesseInitiale);
  p.couleur = couleursProj[typeProjectileCourant];

  projectilesActifs.add(p);
  trajectoires.add(new ArrayList<PVector>());

  tirsRestants--;
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

    trajectoires.get(i).add(new PVector(p.position.x, p.position.y));

    if (toucheCible(p)) {
      projectilesActifs.remove(i);
      trajectoires.remove(i);
      enregistrerToucheCible();
      continue;
    }

    boolean horsEcran = p.position.y > height || p.position.x > width || p.position.x < 0;
    if (horsEcran) {
      projectilesActifs.remove(i);
      trajectoires.remove(i);
    }
  }

  // plus aucun tir disponible et aucun projectile actif
  if (etatJeu == ETAT_EN_COURS && tirsRestants <= 0 && projectilesActifs.isEmpty()) {
    etatJeu = ETAT_DEFAITE;
  }
}

// Nouvelle position de la cible
void genererNouvelleCible() {
  float x = random(width * 0.5, width - 60);
  float y = random(margeHautCible, height - margeBasCible);
  positionCible = new Vecteur3D(x, y, 0);
}

boolean toucheCible(Particule p) {
  float dx = p.position.x - positionCible.x;
  float dy = p.position.y - positionCible.y;
  float distance = sqrt(dx * dx + dy * dy);
  return distance <= (rayonCible + p.rayon / 2.0);
}


// Gestion du score
void enregistrerToucheCible() {
  score++;
  if (score >= SCORE_VICTOIRE) {
    etatJeu = ETAT_VICTOIRE;
  } else {
    genererNouvelleCible();
  }
}

void reinitialiserPartie() {
  projectilesActifs.clear();
  trajectoires.clear();
  score = 0;
  tirsRestants = NB_TIRS_MAX;
  etatJeu = ETAT_EN_COURS;
  genererNouvelleCible();
}


// Fonction générale appelé depuis la game loop
void dessiner() {
  background(18, 22, 38);
  dessinerSol();
  dessinerCible();
  dessinerCanon();
  dessinerTrajectoires();
  dessinerProjectiles();
  dessinerUI();
  dessinerFinDePartie();
}

void dessinerSol() {
  noStroke();
  fill(30, 60, 40);
  rect(0, height - 20, width, 20);
}

void dessinerCible() {
  if (etatJeu != ETAT_EN_COURS) return;
  noStroke();
  fill(255, 60, 60);
  ellipse(positionCible.x, positionCible.y, rayonCible * 2, rayonCible * 2);
  fill(255);
  ellipse(positionCible.x, positionCible.y, rayonCible * 1.1, rayonCible * 1.1);
  fill(255, 60, 60);
  ellipse(positionCible.x, positionCible.y, rayonCible * 0.5, rayonCible * 0.5);
}

void dessinerCanon() {
  pushMatrix();
  translate(positionCanon.x, positionCanon.y);
  rotate(-radians(angleCanon));
  stroke(220); strokeWeight(5);
  line(0, 0, 42, 0);
  popMatrix();
  noStroke(); fill(220);
  ellipse(positionCanon.x, positionCanon.y, 18, 18);
}

void dessinerTrajectoires() {
  noFill();
  for (int i = 0; i < trajectoires.size(); i++) {
    ArrayList<PVector> traj = trajectoires.get(i);
    Particule p = projectilesActifs.get(i);
    stroke(p.couleur, 160);
    strokeWeight(1.5);
    beginShape();
    for (PVector pt : traj) vertex(pt.x, pt.y);
    endShape();
  }
}

void dessinerProjectiles() {
  for (Particule p : projectilesActifs) {
    p.draw();
  }
}

void dessinerUI() {
  fill(255);
  textSize(14);
  text("Projectile [1-4] : " + nomsProjectiles[typeProjectileCourant]
     + "   (masse=" + massesProjectiles[typeProjectileCourant] + "kg, v0="
     + vitessesInit[typeProjectileCourant] + "px/s)", 15, 15);
  text("Angle canon contrôlé par la souris : " + nf(angleCanon, 0, 1) + "°", 15, 35);
  text("Intégrateur [V] : " + (utiliserVerlet ? "Verlet" : "Euler"), 15, 55);
  text("dt : " + nf(dtAffiche * 1000, 0, 2) + " ms   |   FPS : " + nf(1.0/max(dtAffiche,0.0001), 0, 1), 15, 75);
  text("Clic gauche pour tirer   |   [R] Recommencer", 15, 95);
  text("Score : " + score + " / " + SCORE_VICTOIRE + "   |   Tirs restants : " + tirsRestants, 15, 115);
}

void dessinerFinDePartie() {
  if (etatJeu == ETAT_EN_COURS) return;

  noStroke();
  fill(0, 0, 0, 160);
  rect(0, 0, width, height);

  textAlign(CENTER, CENTER);
  textSize(36);
  if (etatJeu == ETAT_VICTOIRE) {
    fill(80, 255, 120);
    text("VICTOIRE ! Cibles touchées : " + score, width / 2, height / 2 - 20);
  } else {
    fill(255, 80, 80);
    text("DÉFAITE... Score final : " + score, width / 2, height / 2 - 20);
  }
  textSize(18);
  fill(255);
  text("Appuyez sur [R] pour recommencer", width / 2, height / 2 + 25);
  textAlign(LEFT, TOP);
}