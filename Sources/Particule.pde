class Particule {
  public color couleur;
  public int rayon;
  public String label = "";
  public Vecteur3D position;
  public Vecteur3D position_precedente;
  public Vecteur3D velocite = new Vecteur3D();
  public Vecteur3D acceleration;
  public float damping;
  public Vecteur3D accumulateur_force = new Vecteur3D();

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

  Particule(Vecteur3D position_initiale, int rayon, float masse, float damping, Vecteur3D velocite_initiale, String label) {
    this(position_initiale, rayon, masse, damping, velocite_initiale);
    this.label = label;
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

  void ajouter_force(Vecteur3D force) {
    accumulateur_force = accumulateur_force.add(force);
  }

  void vider_accumulateur() {
    accumulateur_force = new Vecteur3D();
  }

  void integrer_euler(float temps) {
    if (inverse_masse <= 0){ // éviter qu'un objet de masse infinie ne subisse des calculs inutiles
      return;
    }
    
    acceleration = accumulateur_force.mult(inverse_masse);

    // v1 = v0 + a * dt sans damping
    velocite = velocite.add(acceleration.mult(temps));

    // p1 = p0 + v1 * dt
    position = position.add(velocite.mult(temps));
  }

  void integrer_verlet(float temps) {
    if (inverse_masse <= 0){ // éviter qu'un objet de masse infinie ne subisse des calculs inutiles
      return;
    }

    acceleration = accumulateur_force.mult(inverse_masse);;
    
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
    circle(position.x, position.y, rayon*2); // diamètre

    // Dessin du texte au centre de la boule
    if (label != null && !label.equals("")) {
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(12);
      text(label, position.x, position.y);
    }
  }

  float get_masse() {
    return this.masse;
  }

  float get_inverse_masse() {
    return this.inverse_masse;
  }
}
