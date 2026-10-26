class Mur {
  Vecteur3D p1;
  Vecteur3D p2;
  color couleur;
  float epaisseur;

  Mur(Vecteur3D p1, Vecteur3D p2) {
    this.p1 = p1;
    this.p2 = p2;
    this.couleur = color(200, 200, 255);
    this.epaisseur = 4.0;
  }

  Mur(Vecteur3D p1, Vecteur3D p2, float epaisseur) {
    this.p1 = p1;
    this.p2 = p2;
    this.couleur = color(200, 200, 255);
    this.epaisseur = epaisseur;
  }

  void draw() {
    stroke(couleur);
    strokeWeight(epaisseur);
    line(p1.x, p1.y, p2.x, p2.y);
  }

  Vecteur3D getVecteurDirecteur() {
    return p2.sub(p1);
  }
}