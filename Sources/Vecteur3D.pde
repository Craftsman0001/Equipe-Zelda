class Vecteur3D {
  float x;
  float y;
  float z;

  Vecteur3D(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  Vecteur3D() {
    this.x = 0;
    this.y = 0;
    this.z = 0;
  }

  // Si besoin, on peut remettre cette version mais l'autre était plus pratique 
  // // Addition
  // void add(Vecteur3D v) {
  //   x += v.x;
  //   y += v.y;
  //   z += v.z;
  // }

  // Addition
  Vecteur3D add(Vecteur3D v) {
    return new Vecteur3D(x + v.x, y + v.y, z + v.z);
  }
  
  // Soustraction
  void sub(Vecteur3D v) {
    x -= v.x;
    y -= v.y;
    z -= v.z;
  }

  // Si besoin, on peut remettre cette version mais l'autre était plus pratique 
  // // Multiplication scalaire
  // void mult(float n) {
  //   x *= n;
  //   y *= n;
  //   z *= n;
  // }

   // Multiplication scalaire
  Vecteur3D mult(float n) {
    return new Vecteur3D(x * n, y * n, z * n);
  }
  
  // Produit par composantes
  void mult(Vecteur3D v) {
    x *= v.x;
    y *= v.y;
    z *= v.z;
  }
  
  // Produit scalaire
  float produit_scalaire(Vecteur3D v) {
    return (x * v.x) + (y * v.y) + (z * v.z);
  }
  
  // Produit vectoriel
  Vecteur3D produit_vectoriel(Vecteur3D v) {
    float nx = (y * v.z) - (z * v.y);
    float ny = (z * v.x) - (x * v.z);
    float nz = (x * v.y) - (y * v.x);
    
    return new Vecteur3D(nx, ny, nz);
  }

  // Norme au carree
  float norme_carree() {
    return (x * x) + (y * y) + (z * z);
  }
  
  // Norme
  float norme() {
    return sqrt(norme_carree()); 
  }

  // Rendre le vecteur unitaire
  void normaliser() {
    float m = norme();
    if (m != 0) {
      x /= m;
      y /= m;
      z /= m;
    }
  }
}
