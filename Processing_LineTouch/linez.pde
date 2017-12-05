class Line {
  float a, b, c, slope, y_intercept, x_intercept, ERROR=0.01;
  PVector res=new PVector();
  Line(float a, float b, float c) {
    this.a=a;
    this.b=b;
    this.c=c;
    this.slope=(-a)/b;
    this.y_intercept=c/b;
    this.x_intercept=c/a;
  }
  Line(float m, float c) {
    this.a=m;
    this.b=-1;
    this.c=c;
    this.slope=m;
    this.y_intercept=c;
    this.x_intercept=(-c)/m;
  }

  boolean isParallel(Line target) {
    return abs(this.slope-target.slope)<ERROR;
  }
  

  float[] intersection(Line target) throws Exception {
    if (!this.isParallel(target)) {
      float x, y, d;
      d=target.a*this.b-this.a*target.b;
      x=(target.b*this.c-this.b*target.c)/d;
      y=(this.a*target.c-target.a*this.c)/d;
      float[] res={x, y};
      return res;
    } else {
      throw new Exception("Parallel Lines Don't Intersect");
    }
  }

  PVector intersection(Line target, boolean vec) throws Exception {
    if (!this.isParallel(target)) {
      float x, y, d;
      d=target.a*this.b-this.a*target.b;
      x=(target.b*this.c-this.b*target.c)/d;
      y=(this.a*target.c-target.a*this.c)/d;
      res.set(x,y);
      return res;
    } else {
      throw new Exception("Parallel Lines Don't Intersect");
    }
  }
  
  boolean isPointOnLine(float lx, float ly){
    return abs(this.slope*lx+this.y_intercept-ly)<ERROR;
  }
  
}

class LineSegment {
  float x1, y1, x2, y2, size;
  float slope, x_intercept, y_intercept, ERROR=0.01;
  Line line;
  
  LineSegment(float x1, float y1, float x2, float y2) {
    this.x1=x1;
    this.y1=y1;
    this.x2=x2;
    this.y2=y2;
    // m = slope, y intercept = y1 - slope*x1
    if(x2!=x1){
      this.slope= (y2-y1)/(x2-x1);
    } else {
      this.slope=Float.MAX_VALUE; // avoid infinity by using a very high number
    }
    line= new Line( this.slope, y1-this.slope*x1);
    x_intercept=line.x_intercept;
    y_intercept=line.y_intercept;
  }
  
  float size(){
    return sqrt(pow(x2-x1,2)+pow(y2-y1,2));
  }
  
  boolean isParallel(LineSegment target){
    return this.line.isParallel(target.line);
  }
  
  boolean isParallel(Line target){
    return this.line.isParallel(target);
  }
  
  float[] intersection(LineSegment target) throws Exception{
    return this.line.intersection(target.line);
  }
  
  PVector intersection(LineSegment target, boolean vec) throws Exception{
    return this.line.intersection(target.line, vec);
  }
  
  boolean isIntersecting(LineSegment target) throws Exception{
    // This function checks, if two line segments intersect, within bounds
    if(this.isParallel(target)) return false;
    else return this.isPointOnLineSegment(this.line.intersection(target.line, true)) && target.isPointOnLineSegment(this.line.intersection(target.line, true));
  }
  
  boolean isCollinear(LineSegment target){
    return this.isParallel(target.line) && (this.y_intercept==target.y_intercept);
  }
  
  boolean isPointOnLineSegment(float lx, float ly){
    float l1= sqrt(pow(lx-x1, 2)+pow(ly-y1,2));
    float l2= sqrt(pow(lx-x2, 2)+pow(ly-y2,2));
    return this.line.isPointOnLine(lx, ly) ? abs(l1+l2-this.size())<ERROR : false;
  }
  boolean isPointOnLineSegment(PVector point){
    float lx = point.x;
    float ly = point.y;
    float l1= sqrt((lx-x1)*(lx-x1)+(ly-y1)*(ly-y1));
    float l2= sqrt((lx-x2)*(lx-x2)+(ly-y2)*(ly-y2));
    return this.line.isPointOnLine(lx, ly) ? abs(l1+l2-this.size())<ERROR : false;
  }
}


void setup(){
  size(innerWidth, innerHeight);
  smooth()
}

LineSegment a=null;
LineSegment b=null;
boolean lock=false;
int x0,y0, x1, y1;
int mb;

void draw(){
  boolean inters=false;
  PVector f=new PVector();
  background(0);
  stroke(255);
  strokeWeight(2);
  if(a!=null){
    line(a.y1, a.x1, a.y2, a.x2);
  }
  if(b!=null){
    line(b.y1, b.x1, b.y2, b.x2);
  }
  try{
    inters=a.isIntersecting(b);
    
    f=a.intersection(b,true);
    fill(255,0,0);
    stroke(255,0,0);
    ellipse(f.y, f.x, 2,2);
  } catch (Exception e){
    
  }
  if(a!=null && b!=null){
    fill(255);
    text("Intersection "+inters, 20, 20);
    text("Point "+f.y+" "+f.x, 20, 40);
  }
  
  //text("LOCK"+lock, 100, 140);
}

void mouseDragged(){
  if(mouseButton==LEFT &&!lock){
     //print("DETECTION");
     lock=true;
     x0=mouseX;
     y0=mouseY;
     mb=mouseButton;
  }
  
  else if(mouseButton==LEFT && lock){
    a=new LineSegment(y0, x0, mouseY, mouseX);
  }
  
  if(mouseButton==RIGHT &&!lock){
    lock=true;
    x1=mouseX;
    y1=mouseY;
    mb=mouseButton;
  }
  
  else if(mouseButton==RIGHT && lock){
    b=new LineSegment(y1, x1, mouseY, mouseX);
  }
  
}

void mouseReleased(){
  if(lock && mb==LEFT){
    lock=false;
    a=new LineSegment(y0, x0, mouseY, mouseX);
  }
  else if(lock && mb==RIGHT){
    lock=false;
    b=new LineSegment(y1, x1, mouseY, mouseX);
  }
}
