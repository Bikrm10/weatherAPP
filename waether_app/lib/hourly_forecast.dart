import 'package:flutter/material.dart';
class HourlyForecast extends StatelessWidget {
  final String time;
  final double temperature;
  final IconData icon;
  
   const HourlyForecast({
    super.key,
    required this.time,
    required this.temperature,
    required this.icon

    });

 @override
  Widget build(BuildContext context) {
    return  Card(
                elevation: 6,
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12)
                ),
                  padding: const EdgeInsets.all(8.0),
                  
                  child:   Column(
                    children: [
                      
                      Text(time,
                        maxLines: 1,
                        overflow:TextOverflow.ellipsis,
                        
                        style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                     
                     ),
                  ),
                  
                  const SizedBox(height: 8,),
                  
                  Icon(icon,
                  color: Colors.white,
                  size: 32,
                  ),
                 const SizedBox(height: 8,),
                  
                  
                  Text("${((temperature)-273).toStringAsFixed(2)} °C",
                  style: const TextStyle(
                     
                     fontSize: 12,
                     ),
                  )
                     
                  
                  ]
                  
                  ,),
                )
                ,
                );
  }
}