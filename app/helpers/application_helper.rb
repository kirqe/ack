
    # check session
    # token exists 
    #   user = User.find(token: token)
    #   post.user = user
    #   post.save

    # token doesnt exist
    #   user = User.create(ip: request.ip)
    #         post.user = user
    #   post.save

module ApplicationHelper
end
