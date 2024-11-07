import "package:flutter/material.dart";

void main()
{ runApp(const Converter());
}

class Converter extends StatelessWidget
{
  const Converter({super.key});

  @override
  Widget build(BuildContext context){ 
    return MaterialApp( 
      title: "Converter",
      home: ConverterHome(),
        theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        textTheme: Theme.of(context).textTheme.apply(
          fontSizeFactor: 1.3,
        ),
      ),
    );
  }
}

class ConverterHome extends StatefulWidget
{
  @override
  State<ConverterHome> createState() => ConverterHomeState();
}

class ConverterHomeState extends State<ConverterHome>
{ 
  double value = 0;
  @override
  Widget build( BuildContext context){ 
    Row display = Row(
      children:[
        Container(
          width: 160, 
          height: 40, 
          alignment:Alignment.bottomRight, 
          decoration: BoxDecoration(border: Border.all()), 
          child:  
            Text(
              maxLines:1, 
              style: TextStyle(fontSize: 30),
              (value.round()).toString()
            )
          )
        ]
      ); 


    return Scaffold( 
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:Text("Converter")
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            Column( 
              mainAxisAlignment: MainAxisAlignment.center,
              children:[ 
                display, 
                // top row
                Row( 
                  mainAxisSize:MainAxisSize.min,
                  children: [
                    FloatingActionButton( 
                      onPressed: ()
                      { 
                        setState( ()
                          { 
                            value = appendNum(value, 9); // change to new value with button
                          }
                        );
                      },
                      child: Text("9"),
                    ),
                    FloatingActionButton( 
                      onPressed: ()
                      { 
                        setState( ()
                          { 
                            value = appendNum(value, 8); // change to new value with button
                          }
                        );
                      },
                      child: Text("8"),
                    ),
                    FloatingActionButton( 
                      onPressed: ()
                      { 
                        setState( ()
                          { 
                            value = appendNum(value, 7); // change to new value with button
                          }
                        );
                      },
                      child: Text("7"),
                    ),
                  ]
                ),
                // middle row
                Row(
                  mainAxisSize:MainAxisSize.min,
                  children: [
                    FloatingActionButton( 
                      onPressed: ()
                      { 
                        setState( ()
                          { 
                            value = appendNum(value, 4); // change to new value with button
                          }
                        );
                      },
                      child: Text("4"),
                    ),
                    FloatingActionButton( 
                      onPressed: ()
                      { 
                        setState( ()
                          { 
                            value = appendNum(value, 5); // change to new value with button
                          }
                        );
                      },
                      child: Text("5"),
                    ),
                    FloatingActionButton( 
                      onPressed: ()
                      { 
                        setState( ()
                          { 
                            value = appendNum(value, 6); // change to new value with button
                          }
                        );
                      },
                      child: Text("6"),
                    ),
                  ]
                ),
                // bottom row
                Row(
                  mainAxisSize:MainAxisSize.min,
                  children: [
                    FloatingActionButton( 
                      onPressed: ()
                      { 
                        setState( ()
                          { 
                            value = appendNum(value, 1); // change to new value with button
                          }
                        );
                      },
                      child: Text("1"),
                    ),
                    FloatingActionButton( 
                      onPressed: ()
                      { 
                        setState( ()
                          { 
                            value = appendNum(value, 2); // change to new value with button
                          }
                        );
                      },
                      child: Text("2"),
                    ),
                    FloatingActionButton( 
                      onPressed: ()
                      { 
                        setState( ()
                          { 
                            value = appendNum(value, 3); // change to new value with button
                          }
                        );
                      },
                      child: Text("3"),
                    ),
                  ]
                ),
                Row(
                  mainAxisSize:MainAxisSize.min,
                  children: [
                    FloatingActionButton( 
                      onPressed: ()
                      { 
                        setState( ()
                          { 
                            value = appendNum(value, 0); // change to new value with button
                          }
                        );
                      },
                      child: Text("0"),
                    ),
                    FloatingActionButton( 
                      onPressed: ()
                      { 
                        setState( ()
                          { 
                            value = 0; // change to new value with button
                          }
                        );
                      },
                      child: Text("clear"),
                    ),
                  ]
                ),
              ],
            ),
            Column( 
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Container(
                  width: 80,
                  child: FloatingActionButton( 
                    onPressed: ()
                    { 
                      setState( ()
                        { 
                          value = convertVal(value, "f"); // convert
                        }
                      );
                    },
                    child: Text("c -> f"),
                  ),
                ),
                Container(
                  width: 80,
                  child: FloatingActionButton( 
                    onPressed: ()
                    { 
                      setState( ()
                        { 
                          value = convertVal(value, "c"); // convert
                        }
                      );
                    },
                    child: Text("f -> c"),
                  ),
                ),
                Container(
                  width: 80,
                  child: FloatingActionButton( 
                    onPressed: ()
                    { 
                      setState( ()
                        { 
                          value = convertVal(value, "lb"); // convert
                        }
                      );
                    },
                    child: Text("kg -> lb"),
                  ),
                ),
                Container(
                  width: 80,
                  child: FloatingActionButton( 
                    onPressed: ()
                    { 
                      setState( ()
                        { 
                          value = convertVal(value, "kg"); // convert
                        }
                      );
                    },
                    child: Text("lb -> kg"),
                  ),
                ),
              ],
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

double convertVal(double val, String endChoice)
{
  if(endChoice == "f"){
    val = (val * 9/5) + 32;
  }
  else if(endChoice == "c"){
    val = (val - 32) * 5/9;
  }
  else if(endChoice == "lb"){
    val = val * 2.20462;
  }
  else if(endChoice == "kg"){
    val = val / 2.20462;
  }
  return val;
}


// return value = x but between 0 and c-1
double appendNum(double val, int n)
{
  return ((val * 10) + n);
}

