class Vecteur3D {
  float x;
  float y;
  float z;

  Vecteur3D(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  // Addition
  void add(Vecteur3D v) {
    x += v.x;
    y += v.y;
    z += v.z;
  }
  
  // Soustraction
  void sub(Vecteur3D v) {
    x -= v.x;
    y -= v.y;
    z -= v.z;
  }

  // Multiplication scalaire
  void mult(float n) {
    x *= n;
    y *= n;
    z *= n;
  }
  
  // Produit par composantes
  void mult(Vecteur3D v) {
    x *= v.x;
    y *= v.y;
    z *= v.z;
  }
  
  // Produit scalaire
  float produitScalaire(Vecteur3D v) {
    return (x * v.x) + (y * v.y) + (z * v.z);
  }
  
  // Produit vectoriel
  Vecteur3D produitVectoriel(Vecteur3D v) {
    float nx = (y * v.z) - (z * v.y);
    float ny = (z * v.x) - (x * v.z);
    float nz = (x * v.y) - (y * v.x);
    
    return new Vecteur3D(nx, ny, nz);
  }

  // Norme au carree
  float normeCarree() {
    return (x * x) + (y * y) + (z * z);
  }
  
  // Norme
  float norme() {
    return sqrt(normeCarree()); 
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
