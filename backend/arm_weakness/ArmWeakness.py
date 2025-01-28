from flask import Flask, jsonify
import cv2
import mediapipe as mp
import numpy as np

app = Flask(__name__)

# Initialize MediaPipe Pose module
mp_pose = mp.solutions.pose
pose = mp_pose.Pose()
mp_drawing = mp.solutions.drawing_utils

# Thresholds for detecting arm rotation weakness
ANGLE_THRESHOLD = 30  # Minimum angle to consider proper movement

def calculate_angle(a, b, c):
    """
    Calculate the angle between three points.
    """
    a = np.array([a.x, a.y])
    b = np.array([b.x, b.y])
    c = np.array([c.x, c.y])

    radians = np.arctan2(c[1] - b[1], c[0] - b[0]) - np.arctan2(a[1] - b[1], a[0] - b[0])
    angle = np.abs(radians * 180.0 / np.pi)
    if angle > 180.0:
        angle = 360.0 - angle
    return angle

def analyze_arm_movement(frame, draw=True):
    """
    Analyze arm movement to detect weakness or abnormal motion.
    """
    frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = pose.process(frame_rgb)

    analysis = {
        "status": "No arm movement detected",
        "left_arm_angle": None,
        "right_arm_angle": None,
        "left_arm_weakness": False,
        "right_arm_weakness": False,
    }

    if results.pose_landmarks:
        if draw:
            mp_drawing.draw_landmarks(frame, results.pose_landmarks, mp_pose.POSE_CONNECTIONS)

        # Extract key landmarks for arms
        left_shoulder = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_SHOULDER]
        left_elbow = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_ELBOW]
        left_wrist = results.pose_landmarks.landmark[mp_pose.PoseLandmark.LEFT_WRIST]

        right_shoulder = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_SHOULDER]
        right_elbow = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_ELBOW]
        right_wrist = results.pose_landmarks.landmark[mp_pose.PoseLandmark.RIGHT_WRIST]

        # Calculate angles for arms
        left_arm_angle = calculate_angle(left_shoulder, left_elbow, left_wrist)
        right_arm_angle = calculate_angle(right_shoulder, right_elbow, right_wrist)

        # Detect weakness based on angle threshold
        left_arm_weakness = left_arm_angle < ANGLE_THRESHOLD
        right_arm_weakness = right_arm_angle < ANGLE_THRESHOLD

        # Update frame with information
        if draw:
            cv2.putText(frame, f"Left Angle: {int(left_arm_angle)}", (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 0.7,
                        (0, 255, 0) if not left_arm_weakness else (0, 0, 255), 2)
            cv2.putText(frame, f"Right Angle: {int(right_arm_angle)}", (50, 80), cv2.FONT_HERSHEY_SIMPLEX, 0.7,
                        (0, 255, 0) if not right_arm_weakness else (0, 0, 255), 2)
            cv2.putText(frame, "Weakness Detected!" if left_arm_weakness or right_arm_weakness else "No Weakness",
                        (50, 110), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 0, 255) if left_arm_weakness or right_arm_weakness else (0, 255, 0), 2)

        analysis.update({
            "status": "Arm movement detected",
            "left_arm_angle": left_arm_angle,
            "right_arm_angle": right_arm_angle,
            "left_arm_weakness": left_arm_weakness,
            "right_arm_weakness": right_arm_weakness,
        })

    return analysis

@app.route('/detect', methods=['GET'])
def detect():
    """
    API endpoint for detecting arm movement weakness.
    """
    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        return jsonify({"error": "Camera not accessible"})

    ret, frame = cap.read()
    if not ret:
        return jsonify({"error": "Failed to read frame"})

    results = analyze_arm_movement(frame, draw=False)
    cap.release()

    return jsonify(results)

def live_video_analysis():
    """
    Real-time video analysis for arm movement with feedback displayed on the screen.
    """
    cap = cv2.VideoCapture(0)

    if not cap.isOpened():
        print("Error: Unable to access the camera")
        return

    while True:
        ret, frame = cap.read()
        if not ret:
            print("Failed to grab frame")
            break

        analysis = analyze_arm_movement(frame)

        # Show the frame with annotations
        cv2.imshow("Arm Movement Detection", frame)

        # Break the loop on pressing 'q'
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == "__main__":
    import threading

    # Start the Flask API in a separate thread
    flask_thread = threading.Thread(target=lambda: app.run(host="0.0.0.0", port=5000, debug=False))
    flask_thread.daemon = True
    flask_thread.start()

    # Start the real-time video analysis
    live_video_analysis()


'''
import cv2
import mediapipe as mp
import time
import math
from collections import deque

# Initialize mediapipe pose module
mp_pose = mp.solutions.pose
pose = mp_pose.Pose()

# Initialize variables
start_time = time.time()
total_run_time = 15  # Set the total run time in seconds
alpha = 0.2  # Smoothing factor for EMA
dynamic_threshold_factor = 1.5  # Factor for dynamic thresholding
baseline_distance = None  # Initialize baseline distance
rolling_window_size = 5  # Number of frames to use for rolling average

# Initialize a deque to store recent distances for rolling average
distance_window = deque(maxlen=rolling_window_size)

# Variable to store the final result
final_result = "No Arm Weakness Detected!"

# Function to calculate distance between two points
def calculate_distance(point1, point2):
    return math.sqrt((point1[0] - point2[0]) ** 2 + (point1[1] - point2[1]) ** 2)

# Open camera
cap = cv2.VideoCapture(0)

# Calibration period to establish baseline distance
calibration_duration = 2  # Calibration duration in seconds
calibration_start_time = time.time()

while cap.isOpened() and (time.time() - start_time) < total_run_time:
    # Read frame from the camera
    ret, frame = cap.read()
    if not ret:
        break

    # Get the frame dimensions (width and height)
    screen_height, screen_width = frame.shape[:2]

    # Convert the BGR image to RGB
    rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    # Process the image to get pose landmarks
    results = pose.process(rgb_frame)

    if results.pose_landmarks:
        # Get landmarks for arms
        arm_landmarks = results.pose_landmarks.landmark

        # Draw landmarks on the frame
        for landmark in arm_landmarks:
            cx, cy = int(landmark.x * screen_width), int(landmark.y * screen_height)
            cv2.circle(frame, (cx, cy), 5, (0, 255, 0), -1)

        # Calculate distance between arms (wrist landmarks)
        distance_between_arms = calculate_distance(
            (arm_landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x * screen_width,
             arm_landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y * screen_height),
            (arm_landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].x * screen_width,
             arm_landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].y * screen_height)
        )

        # Store distances during calibration
        if (time.time() - calibration_start_time) < calibration_duration:
            distance_window.append(distance_between_arms)
            print("Calibration Distance:", distance_between_arms)
        else:
            # Calculate baseline distance after calibration period
            if baseline_distance is None:
                baseline_distance = sum(distance_window) / len(distance_window)
                print("Baseline Distance established:", baseline_distance)

            # Update the distance window
            distance_window.append(distance_between_arms)

            # Calculate rolling average
            rolling_average_distance = sum(distance_window) / len(distance_window)

            # Determine the dynamic threshold
            dynamic_threshold = baseline_distance * dynamic_threshold_factor
            print("Dynamic Threshold:", dynamic_threshold)

            # Check if the rolling average distance is above the dynamic threshold
            if rolling_average_distance > dynamic_threshold:
                final_result = "No Arm Weakness Detected!"
            else:
                final_result = "Arm Weakness Detected!"

            # Optional: Print the current rolling average distance for debugging
            print("Rolling Average Distance:", rolling_average_distance)

        # Draw lines between arms
        cv2.line(frame,
                 (int(arm_landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].x * screen_width),
                  int(arm_landmarks[mp_pose.PoseLandmark.LEFT_WRIST.value].y * screen_height)),
                 (int(arm_landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].x * screen_width),
                  int(arm_landmarks[mp_pose.PoseLandmark.RIGHT_WRIST.value].y * screen_height)),
                 (0, 255, 0), 2)

    # Display the frame
    cv2.imshow('Arm Tracking', frame)

    # Break the loop if 'q' is pressed
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Print the final result after the loop ends
print(final_result)

# Release the camera and close all windows
cap.release()
cv2.destroyAllWindows()
'''