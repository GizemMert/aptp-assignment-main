// Copyright 2019 Intelligent Robotics Lab
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <memory>
#include <algorithm>

#include "plansys2_executor/ActionExecutorClient.hpp"

#include "rclcpp/rclcpp.hpp"
#include "rclcpp_action/rclcpp_action.hpp"

using namespace std::chrono_literals;

class MoveAction : public plansys2::ActionExecutorClient
{
public:
  MoveAction()
  : plansys2::ActionExecutorClient("move", 500ms)
  {
    progress_ = 0.0;
  }

private:
  void do_work()
  {
    if (progress_ < 1.0) {
      progress_ += 0.10;
      send_feedback(progress_, "movet running");
    } else {
      finish(true, 1.0, "move completed");

      progress_ = 0.0;
      std::cout << std::endl;
    }

    // preparing the string to display the arguments
    std::vector<std::string> arguments_ = get_arguments();
    std::string s = "";
    for (size_t i = 0; i < arguments_.size(); i++) {
      std::string item = arguments_[i];
      s = s + item;
      if(i < arguments_.size()-1){
        s = s + ", ";
      }
    }
    std::cout << "\r\e[K" << std::flush;
    std::cout << "Moving to another location ... args = (" << s << ") completion = " <<  std::min(100.0, progress_ * 100.0) << "% " <<
      std::flush;
  }

  float progress_;
};

int main(int argc, char ** argv)
{
  rclcpp::init(argc, argv);
  auto node = std::make_shared<MoveAction>();

  node->set_parameter(rclcpp::Parameter("action_name", "move"));
  node->trigger_transition(lifecycle_msgs::msg::Transition::TRANSITION_CONFIGURE);

  rclcpp::spin(node->get_node_base_interface());

  rclcpp::shutdown();

  return 0;
}