module Roadmap

  def get_roadmap(roadmap_id)
    response = self.class.get(base_uri("/roadmaps/#{roadmap_id}"), headers: { "authorization" => @auth_token })
    @roadmap_data = JSON.parse(response.body)
  end

  def get_checkpoint(checkpoint_id)
    response = self.class.get(base_uri("/checkpoints/#{checkpoint_id}"), headers: { "authorization" => @auth_token })
    @checkpoint_data = JSON.parse(response.body)
  end

end
