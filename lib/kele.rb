require 'httparty'
require 'json'
require './lib/roadmap'


class Kele
  include HTTParty
  include Roadmap

  def initialize(email, password)
    response = self.class.post(base_uri("sessions"), body: {"email": email, "password": password})
    raise response["message"] if response.code != 200
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(base_uri("users/me"), headers: { "authorization" => @auth_token })
    @user_data = JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(base_uri("/mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
  end

  def get_messages(page_id = nil)
    response = self.class.get(base_uri("/message_threads#{page_parser(page_id)}"), headers: { "authorization" => @auth_token })
    @messages = JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, subject, message)
    response = self.class.post(base_uri("/messages"),
      body: {
        "sender": sender,
        "recipient_id": recipient_id,
        "subject": subject,
        "stripped-text": message
        },
      headers: { "authorization" => @auth_token })
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    self.get_me
    response = self.class.post(base_uri("/checkpoint_submissions"),
      body: {
        "assignment_branch": assignment_branch,
        "assignment_commit_link": assignment_commit_link,
        "checkpoint_id": checkpoint_id,
        "comment": comment,
        "enrollment_id": @user_data["current_enrollment"]["id"]
        },
      headers: { "authorization" => @auth_token })
  end

  private
  def base_uri(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end

  def page_parser(page_id)
    if page_id == nil
      nil
    else
      "?page=#{(page_id)}"
    end
  end
end
