class Particule {
  public color couleur;
  public int rayon;
  public Vecteur3D position;
  public Vecteur3D position_precedente;
  public Vecteur3D velocite = new Vecteur3D();
  public Vecteur3D acceleration = new Vecteur3D();
  public float damping = 0.8;
  public float masse;

  protected float inverse_masse;

  Particule(float x, float y, float z, int rayon, float masse) {
    this.position = new Vecteur3D(x, y, z);
    this.rayon = rayon;
    this.masse = masse;
    set_inverse_masse(masse);

    couleur_aleatoire();
  }

  void couleur_aleatoire() {
    float r = random(0, 255);
    float g = random(0, 255);
    float b = random(0, 255);
    this.couleur = color(r, g, b, 255);
  }

  void integrer_euler(float temps) {
    Vecteur3D force = new Vecteur3D();
    Vecteur3D g = new Vecteur3D(0.0, 200.0, 0.0);
    force = g.mult(masse);

    acceleration = force.mult(inverse_masse);

    // v1 = v0 + a * dt avec damping sur v0
    velocite = velocite.mult(pow(damping, temps)).add(acceleration.mult(temps));

    // p1 = p0 + v1 * dt
    position = position.add(velocite.mult(temps));
  }

  void integrer_velvet(float temps) {
    Vecteur3D force = new Vecteur3D();
    Vecteur3D g = new Vecteur3D(0.0, 200.0, 0.0);
    force = f.mult(masse);
    
    acceleration = force.mult(inverse_masse);
    
    if (position_precedente == null){
      position_precedente = position.add(velocite.mult(-temps));
   
    }
    
    Vecteur3D nouvelle_position = position.mult(2.0).add(position_precedente.mult(-1.0)).add(acceleration.mult(temps * temps));
    
    velocite = nouvelle_position.add(position_precedente.mult(-1.0)).mult(1.0 / (2.0 * temps));
    
    position_precedente = position;
    position = nouvelle_position;
  }

  void draw() {
    stroke(couleur);
    fill(couleur);
    circle(position.x, position.y, rayon);
  }

  void set_inverse_masse(float masse) {
    if (masse <= 0) {
        this.inverse_masse = 0.0;
    } else {
        this.inverse_masse = 1/masse;
    }
  }

  float get_inversse_masse() {
    return this.inverse_masse;
  }
}
