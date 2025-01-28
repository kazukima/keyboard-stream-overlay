extends Node

var server := UDPServer.new()
var peers = []


func _ready():
	server.listen(12345)


func _process(delta):
	server.poll()
	if server.is_connection_available():
		var peer: PacketPeerUDP = server.take_connection()
		var packet = peer.get_packet()
		GlobalEvents.emit_udp_keyboard_event(packet.get_string_from_utf8())
		#print("Accepted peer: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
		#print("Received data: %s" % [packet.get_string_from_utf8()])
