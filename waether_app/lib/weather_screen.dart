import 'dart:convert';
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:waether_app/addtional_items.dart';
import 'package:waether_app/hourly_forecast.dart';
//http
import 'package:http/http.dart' as http;
import 'package:waether_app/secret.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  
  const WeatherScreen({super.key});
  

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future <Map<String,dynamic>?> weather;
  Future<Map<String,dynamic>> getCurrentWeather() async{
    try{
    
      String cityName = 'Kathmandu';
      var response = await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$APIKey"));

    // print('the body of the response ${jsonDecode(response.body.toString())}');

      final data = jsonDecode(response.body);

      if(data['cod']!='200'){
      throw "An unexpected error ocured";
      }
      return  data;
    }
    catch(e){
      throw(e.toString());
    }
    
    
  }
  @override
  void initState() {
      weather = getCurrentWeather();
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Weather App",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          ),
          ),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions:   [
          IconButton(onPressed: (){
            setState(() {
              
            });
            weather = getCurrentWeather();
            //  CircularProgressIndicator();
          },   // inkwel type provides little splash
          icon: const Icon(Icons.refresh)),
          ],
        
      ),
//body
body:  FutureBuilder(
  future: getCurrentWeather(),
  builder: (context,snapshot) {
    // print(snapshot);
    // print(snapshot.runtimeType);
    if (snapshot.connectionState == ConnectionState.waiting){
               return const Center(
                child: CircularProgressIndicator.adaptive());
    }
    if(snapshot.hasError){
      return Center(
        child: Text(snapshot.error.toString()));
    }

    // data initialization

    final data = snapshot.data!;
    final currentWeather = data['list'][0];
    double currentTemp = currentWeather['main']['temp'];
    final currentPressure = currentWeather['main']['pressure'];
    final currentHumidity = currentWeather['main']['humidity'];

    final skyCloud = currentWeather['weather'][0]['main'];
    final currentWindSpeed = currentWeather['wind']['speed'];
    return Padding(
      padding:  const EdgeInsets.all(16.0),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
      
          //main cards
           SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 8,
                      sigmaY: 8,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          
                          Text("${((currentTemp)-273).toStringAsFixed(2)} °C",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                        ),
                        ),
                           const SizedBox(height: 16,),
                           Icon(
                            skyCloud == 'Clouds'||skyCloud =="rain"? Icons.cloud:Icons.sunny,
                            size: 64,
                            color: Colors.white,
                            ),
                           const SizedBox(height: 16,),
                           Text("$skyCloud",
                          style: const TextStyle(
                            fontSize: 20
                          ),),
                      
                        ],
                        
                      ),
                    ),
                  ),
                ),
              ),
             
             ),
             
           
            
          
      
      
          const SizedBox(height: 20,),    //gap after main card
    
    //weather forecast
          const Text("Weather Forecast",
          style: TextStyle(fontSize: 24,
          fontWeight: FontWeight.bold
          ),
          ),
          const SizedBox(height: 20,),
    
          //  SingleChildScrollView(
          //   scrollDirection:Axis.horizontal ,
          //   child: Row(
          //     children: [
          //       for( int i = 0; i<5 ; i++)
          //       HourlyForecast(
          //         time: data['list'][i+1]['dt'].toString(),
          //         temperature: data['list'][i+1]['main']['temp'].toString(),
          //         icon: data['list'][i+1]['weather'][0]['main'] == 'Clouds'||data['list'][i+1]['weather'][0]['main'] =="rain"? Icons.cloud:Icons.sunny,
          //       ),
          //       ],
          //   ),
          // ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                final  hourlyForecast = data['list'][index + 1];
                double hourlytemperature = hourlyForecast['main']['temp'];
                final hourlytime = hourlyForecast['dt_txt'].toString();
                final skyCloud = hourlyForecast['weather'][0]['main'].toString();
                final time = DateTime.parse(hourlytime);
                // 00:00 = hour: minute
                final tomeOnly = DateFormat.j().format(time);
                return  HourlyForecast(
                  icon:skyCloud == 'Clouds'||skyCloud =="rain"? Icons.cloud:Icons.sunny,
                  temperature: hourlytemperature,
                  time:tomeOnly.toString() ,);
            
              },
              
            ),
          ),
    
         const SizedBox(height: 20,),//gap
      
      
      
          //additional card
          const Text("Weather Forecast",
          style: TextStyle(fontSize: 24,
          fontWeight: FontWeight.bold
          ),
          ),
          const SizedBox(height: 8,),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:  [
               AdditionalItems(icon: Icons.water_drop,label:'Humidity',value:"$currentHumidity",),
               AdditionalItems(icon: Icons.air, label:'Wind Speed',value: '$currentWindSpeed',),
               AdditionalItems(icon: Icons.beach_access,label:'Pressure',value: "$currentPressure",),
              ],
          )
    
      
        ],),
    );
  }
),

    );
  }
}
