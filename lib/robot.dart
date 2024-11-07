import "package:flutter/material.dart";

void main()
{ runApp(const Robot());
}

class Robot extends StatelessWidget
{
  const Robot({super.key});

  @override
  Widget build(BuildContext context){ 
    return MaterialApp( 
      title: "robot",
      home: RobotHome(),
        theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
    );
  }
}

class RobotHome extends StatefulWidget
{
  @override
  State<RobotHome> createState() => RobotHomeState();
}

class RobotHomeState extends State<RobotHome>
{ 
  final sizeX = 5;
  final sizeY = 5;

  int robotX = 2;
  int robotY = 2;

  Coords robotAt = Coords(2,2);

  int boxX = 3;
  int boxY = 3;

  Coords boxAt = Coords(3,3);

  // move robot 1 click in direction dir inx (inx true)
  // or in y .
  void move(int dir, bool inx){ 
    print("move starting ...");
    Coords d = robotAt.next(dir,inx);
    if (isLegal(d)){ 
      if (!d.equals(boxAt)) { // then you're moving robot
        robotAt.set(d);
        print("robot moves to ${robotAt.x},${robotAt.y}");
      }
      else{ // then you're moving box
        Coords e = boxAt.next(dir,inx);
        if (isLegal(e)){ 
          // boxAt = e;
          boxAt.set(e);
          // robotAt = d;
          robotAt.set(d);
        }
        else{
          print("invalid move!");
        }
      }
    }
    else{
      print("invalid move!");
    }
  }

  bool isLegal( Coords c )
  { return    c.x >= 0 && c.x < sizeX
           && c.y >= 0 && c.y < sizeY;
  }
  
  @override
  Widget build( BuildContext context){ 
    Column board = Column(children:[]); 
    for (int y=0; y<sizeY; y++){ 
      Row row = Row(mainAxisSize:MainAxisSize.min, children:[]);
      for (int x=0; x<sizeX; x++){
        String r = (x==robotAt.x && y==robotAt.y)? " R" 
                   : (x==boxAt.x && y==boxAt.y)? " □": "";
        Container cell = Container( 
          decoration:  BoxDecoration( 
            border: Border.all(width:2,color:Theme.of(context).colorScheme.secondary),
          ),
          width: 40,
          height: 40,
          child: Text(r, style: TextStyle(fontSize: 25)),
        );
        row.children.add(cell);
      }
      board.children.add(row);
    }
    return Scaffold( 
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:Text("Robot")
      ),
      body: Center(
        child: Column( 
          mainAxisAlignment: MainAxisAlignment.center,
          children:[ 
            board, 
            // top row
            Row( 
              mainAxisSize:MainAxisSize.min,
              children: [
                FloatingActionButton( 
                  onPressed: ()
                  { 
                    setState( ()
                      { 
                        robotY -= 1;
                        robotY = cap(robotY,sizeY);
                        move(-1,false);
                      }
                    );
                  },
                  child: Text("up"),
                ),
              ]
            ),
            // middle row
            Row(
              mainAxisSize:MainAxisSize.min,
              children: [
                FloatingActionButton( 
                  onPressed: (){ 
                    setState( ()
                      { 
                        robotX -= 1;
                        robotX = cap(robotX,sizeX);
                        move(-1, true);
                      }
                    );
                  },
                  child: Text("left"),
                ),
                FloatingActionButton( 
                  onPressed: (){ 
                    setState( ()
                      { 
                        robotAt.set(Coords(2,2));
                        boxAt.set(Coords(3,3));
                      }
                    );
                  },
                  child: Text("reset"),
                ),
                FloatingActionButton( 
                  onPressed: (){ 
                    setState( ()
                      { 
                        robotX += 1;
                        robotX = cap(robotX,sizeX);
                        move(1,true);
                      }
                    );
                  },
                  child: Text("right"),
                ),
              ]
            ),
            // bottom row
            Row(
              mainAxisSize:MainAxisSize.min,
              children: [
                FloatingActionButton( 
                  onPressed: (){ 
                    setState( ()
                      { 
                        robotY += 1;
                        robotY = cap(robotY,sizeY);
                        move(1,false);
                      }
                    );
                  },
                  child: Text("down"),
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}

class Coords
{
  int x;
  int y;

  Coords(this.x, this.y);

  bool equals(Coords c){ return c.x == x && c.y == y;}

  void set(Coords c){ 
    x = c.x;
    y = c.y;
  }
  // i WANTED to try and use both arguments as coordinates, but it seems
  // just easier to use a bool (bc you're only ever moving in one direction)
  Coords next(int dir, bool inx){
    Coords d = Coords(x,y);
    if(inx){d.x += dir;}
    else{d.y += dir;}
    return d;
  }
}


// return value = x but between 0 and c-1
int cap(int x, int c)
{
   if (x<0){x = 0;}
   if (x>=c){x = c-1;}
   return x;
}

