import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../viewModel/blocs/auth/auth_bloc.dart';
import '../viewModel/blocs/post/post_bloc.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(LoadPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade300, Colors.purple.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Column(
            children: [
              // AppBar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Quick Post",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: Colors.white),
                        onPressed: () {
                          context.read<AuthBloc>().add(SignOutEvent());
                          Navigator.pushReplacementNamed(context, "/login");
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Post Input Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 5),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _postController,
                            decoration: InputDecoration(
                              hintText: "What's on your mind?",
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.edit, color: Colors.blueAccent),
                            ),
                          ),
                        ),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            String username = (state is Authenticated) ? state.username : "Unknown User";
                            return IconButton(
                          icon: Icon(Icons.send, color: Colors.blueAccent),
                          onPressed: () {
                            context.read<PostBloc>().add(AddPostEvent(
                              _postController.text,
                              username,
                            ));
                            _postController.clear();
                          },
                        );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Post List
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  ),
                  child: BlocBuilder<PostBloc, PostState>(
                    builder: (context, state) {
                      if (state is PostsLoaded) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: state.posts,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                            var posts = snapshot.data!.docs;
                            return ListView.builder(
                              padding: EdgeInsets.all(16),
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                var post = posts[index];
                                return Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blueAccent,
                                      child: Text(post["username"][0].toUpperCase(), style: TextStyle(color: Colors.white)),
                                    ),
                                    title: Text(post["username"], style: TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text(post["message"]),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
