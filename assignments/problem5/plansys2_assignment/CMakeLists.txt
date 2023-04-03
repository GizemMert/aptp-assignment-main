cmake_minimum_required(VERSION 3.5)
project(plansys2_simple_example)


find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(rclcpp_action REQUIRED)
find_package(plansys2_msgs REQUIRED)
find_package(plansys2_executor REQUIRED)

set(CMAKE_CXX_STANDARD 17)

set(dependencies
    rclcpp
    rclcpp_action
    plansys2_msgs
    plansys2_executor
)

add_executable(check_empty_action_node src/check_empty_action_node.cpp)
ament_target_dependencies(check_empty_action_node ${dependencies})

add_executable(check_safe_action_node src/check_safe_action_node.cpp)
ament_target_dependencies(check_safe_action_node ${dependencies})

add_executable(continue_empty_action_node src/continue_empty_action_node.cpp)
ament_target_dependencies(continue_empty_action_node ${dependencies})

add_executable(deliver_action_node src/deliver_action_node.cpp)
ament_target_dependencies(deliver_action_node ${dependencies})

add_executable(fill_action_node src/fill_action_node.cpp)
ament_target_dependencies(fill_action_node ${dependencies})

add_executable(move_action_node src/move_action_node.cpp)
ament_target_dependencies(move_action_node ${dependencies})

add_executable(pickup_action_node src/pickup_action_node.cpp)
ament_target_dependencies(pickup_action_node ${dependencies})

add_executable(start_empty_action_node src/start_empty_action_node.cpp)
ament_target_dependencies(start_empty_action_node ${dependencies})



install(DIRECTORY launch pddl DESTINATION share/${PROJECT_NAME})

install(TARGETS
  check_empty_action_node
  check_safe_action_node
  continue_empty_action_node
  deliver_action_node
  fill_action_node
  move_action_node
  pickup_action_node
  start_empty_action_node
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION lib/${PROJECT_NAME}
)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()

  find_package(ament_cmake_gtest REQUIRED)
endif()

ament_export_dependencies(${dependencies})

ament_package()