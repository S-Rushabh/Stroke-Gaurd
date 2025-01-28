import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // For animations

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimationLimiter(
          child: ListView(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                // Title Section
                const Text(
                  "Stroke Recognition with FAST",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006a94), // Highlighted title color
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "FAST is an easy way to identify common symptoms of a stroke. Recognizing these symptoms quickly can help save a life. "
                      "If you or someone else experiences any of these signs, seek immediate medical help.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                // FAST Section with Icons and Explanations
                _buildFastRow(
                  icon: Icons.face_rounded,
                  boldText: "F - Face Drooping",
                  description:
                  "Ask the person to smile. Does one side of the face droop or is it numb?",
                  additionalInfo: [
                    "Face drooping can indicate weakness in the muscles caused by a stroke.",
                    "Check if the person has difficulty moving one side of their mouth or eye."
                  ],
                ),
                const SizedBox(height: 20),
                _buildFastRow(
                  icon: Icons.fitness_center_rounded,
                  boldText: "A - Arm Weakness",
                  description:
                  "Ask the person to raise both arms. Does one arm drift downward or feel weak?",
                  additionalInfo: [
                    "Arm weakness can make it difficult to hold objects or perform simple tasks.",
                    "Observe if the person struggles to keep both arms at the same level."
                  ],
                ),
                const SizedBox(height: 20),
                _buildFastRow(
                  icon: Icons.record_voice_over_rounded,
                  boldText: "S - Speech Difficulty",
                  description:
                  "Ask the person to repeat a simple sentence. Is their speech slurred or hard to understand?",
                  additionalInfo: [
                    "Speech difficulty can include trouble forming words or speaking clearly.",
                    "The person may seem confused or unable to comprehend simple instructions."
                  ],
                ),
                const SizedBox(height: 20),
                _buildFastRow(
                  icon: Icons.access_time_filled_rounded,
                  boldText: "T - Time to Call for Help",
                  description:
                  "If any of these symptoms are present, it’s time to call emergency services immediately.",
                  additionalInfo: [
                    "Every second counts when dealing with a stroke. Don’t delay.",
                    "Inform emergency responders of all observed symptoms for faster care."
                  ],
                ),
                const SizedBox(height: 30),

                // Conclusion Section
                const Text(
                  "Remember: Acting fast can save lives. If you notice any of the FAST symptoms, seek help immediately.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Method to Build FAST Row
  Widget _buildFastRow({
    required IconData icon,
    required String description,
    required String boldText,
    required List<String> additionalInfo,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF006a94).withOpacity(0.1), // Light circle background
              ),
              child: Icon(
                icon,
                color: const Color(0xFF006a94),
                size: 32,
              ),
            ),
            const SizedBox(width: 16), // Space between icon and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    boldText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Additional Info
        ...additionalInfo.map(
              (info) => Padding(
            padding: const EdgeInsets.only(left: 56.0),
            child: Text(
              "- $info",
              style: const TextStyle(fontSize: 14, color: Colors.black45),
            ),
          ),
        ),
      ],
    );
  }
}
