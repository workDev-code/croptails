## Component dùng chung để phát hiện Player vào/rời vùng tương tác.
## Đối tượng cha quyết định phản ứng bằng cách kết nối các signal của component này.
class_name Interactable
extends Area2D

## Phát ra khi một Player đi vào vùng Area2D của đối tượng tương tác.
signal player_entered(player: Node2D)
## Phát ra khi một Player rời khỏi vùng Area2D của đối tượng tương tác.
signal player_exited(player: Node2D)
## Phát ra khi hệ thống tương tác yêu cầu kích hoạt hành động trên đối tượng này.
signal interacted(player: Node2D)


## Thiết lập kết nối signal Area2D ngay khi component được khởi tạo.
## Godot gọi hàm này một lần sau khi node và các node con đã sẵn sàng.
func _ready() -> void:
    add_to_group("interactable")
    # Tự động gọi hàm xử lý khi có một PhysicsBody đi vào vùng Area2D.
    body_entered.connect(_on_body_entered)
    # Tự động gọi hàm xử lý khi một PhysicsBody rời khỏi vùng Area2D.
    body_exited.connect(_on_body_exited)


## Xử lý khi một PhysicsBody đi vào Area2D.
## Godot gọi hàm này thông qua body_entered; hàm bỏ qua vật thể không thuộc group "player".
func _on_body_entered(body: Node2D) -> void:
    # is_in_group giúp phân biệt Player với tường, vật phẩm hoặc node vật lý khác.
    if body.is_in_group("player"):
        print("[INTERACTABLE] Player entered")
        # Gửi Player đang tương tác để node cha biết chính xác ai kích hoạt.
        player_entered.emit(body)


## Xử lý khi một PhysicsBody rời khỏi Area2D.
## Godot gọi hàm này thông qua body_exited; hàm bỏ qua vật thể không thuộc group "player".
func _on_body_exited(body: Node2D) -> void:
    # Chỉ phát signal khi node rời đi thực sự là Player.
    if body.is_in_group("player"):
        print("[INTERACTABLE] Player exited")
        # Gửi Player đã rời vùng để đối tượng cha có thể đóng prompt tương tác.
        player_exited.emit(body)


## Yêu cầu kích hoạt tương tác từ một Player đang nằm trong vùng tương tác.
## Hàm này được script điều khiển đối tượng, chẳng hạn DoorController, gọi khi người chơi nhấn E.
func interact(player: Node2D) -> void:
    # Phát signal để node cha hoặc script cụ thể xử lý hành động tương ứng.
    interacted.emit(player)
    print("[INTERACTABLE] Signal emitted: interacted")