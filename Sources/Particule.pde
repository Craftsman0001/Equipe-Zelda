class Particule {
  public color couleur;
  public int rayon;
  public Vecteur3D position;
  public Vecteur3D position_precedente;
  public Vecteur3D velocite = new Vecteur3D();
  public Vecteur3D acceleration;
  public float damping;

  private float masse;
  private float inverse_masse;

  Particule(Vecteur3D position_initiale, int rayon, float masse, float damping, Vecteur3D velocite_initiale) {
    this.position = position_initiale;
    this.rayon = rayon;
    this.damping = damping;
    this.velocite = velocite_initiale;
    this.acceleration = new Vecteur3D();

    set_masse(masse);
    couleur_aleatoire();
  }

  void set_masse(float nouvelle_masse) {
    this.masse = nouvelle_masse;
    
    if (nouvelle_masse <= 0) {
        this.inverse_masse = 0.0;
    } else {
        this.inverse_masse = 1.0 / nouvelle_masse;
    }
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

  void integrer_verlet(float temps) {
    Vecteur3D force = new Vecteur3D();
    Vecteur3D g = new Vecteur3D(0.0, 200.0, 0.0);
    force = g.mult(masse);
    
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

  float get_masse() {
    return this.masse;
  }

  float get_inverse_masse() {
    return this.inverse_masse;
  }
}
