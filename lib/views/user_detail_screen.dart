import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dummy_connect/model/user_model.dart';
import 'package:dummy_connect/model/post_model.dart';
import 'package:dummy_connect/model/todo_model.dart';
import 'package:dummy_connect/controllers/blocs/user_detail_bloc/user_detail_bloc.dart';
import 'package:dummy_connect/controllers/blocs/user_detail_bloc/user_detail_events.dart';
import 'package:dummy_connect/controllers/blocs/user_detail_bloc/user_detail_states.dart';
import 'package:dummy_connect/controllers/cubits/post_create/post_create_cubit.dart';
import 'package:dummy_connect/controllers/cubits/post_create/post_create_state.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserDetailBloc(
            userRepository: context.read(),
          )..add(LoadUserDetail(user.id)),
        ),
        BlocProvider(
          create: (context) => PostCubit(),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<UserDetailBloc, UserDetailState>(
          builder: (context, state) {
            if (state is UserDetailLoading) {
              return const _LoadingView();
            }
            
            if (state is UserDetailError) {
              return _ErrorView(
                error: state.message,
                onRetry: () => context.read<UserDetailBloc>().add(LoadUserDetail(user.id)),
              );
            }
            
            if (state is UserDetailLoaded) {
              return _UserDetailContent(userDetailState: state);
            }
            
            return const _LoadingView();
          },
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () => _showCreatePostDialog(context),
        //   icon: const Icon(Icons.add),
        //   label: const Text('Create Post'),
        //   backgroundColor: const Color(0xFF6366F1),
        // ),
      ),
    );
  }

  // void _showCreatePostDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (dialogContext) => BlocProvider.value(
  //       value: context.read<PostCubit>(),
  //       child: _CreatePostDialog(userId: user.id),
  //     ),
  //   );
  // }
}

class _UserDetailContent extends StatelessWidget {
  final UserDetailLoaded userDetailState;

  const _UserDetailContent({required this.userDetailState});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserDetailBloc>().add(RefreshUserDetail(userDetailState.user.id));
      },
      child: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildUserInfo(),
                const SizedBox(height: 20),
                _buildStatsCards(),
                const SizedBox(height: 20),
                _buildTabSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                _buildAvatar(),
                const SizedBox(height: 12),
                Text(
                  userDetailState.user.fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '@${userDetailState.user.username}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipOval(
        child: userDetailState.user.image.isNotEmpty
            ? Image.network(
                userDetailState.user.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildInitialsAvatar(),
              )
            : _buildInitialsAvatar(),
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    return Container(
      color: const Color(0xFF8B5CF6),
      child: Center(
        child: Text(
          userDetailState.user.initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(Icons.email, 'Email', userDetailState.user.email),
              _buildInfoRow(Icons.phone, 'Phone', userDetailState.user.phone),
              _buildInfoRow(Icons.business, 'Company', userDetailState.user.company.name),
              _buildInfoRow(Icons.work, 'Role', userDetailState.user.role),
              _buildInfoRow(Icons.location_on, 'Location', userDetailState.user.address.city),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF6366F1)),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    final posts = userDetailState.posts ?? [];
    final todos = userDetailState.todos ?? [];
    final completedTodos = todos.where((t) => t.completed).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Posts', posts.length.toString(), Icons.article)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Todos', todos.length.toString(), Icons.task)),
          const SizedBox(width: 12),
          Expanded(child: _buildStatCard('Completed', completedTodos.toString(), Icons.done)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 30, color: const Color(0xFF6366F1)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSection() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Color(0xFF6366F1),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF6366F1),
            tabs: [
              Tab(text: 'Posts', icon: Icon(Icons.article)),
              Tab(text: 'Todos', icon: Icon(Icons.task)),
            ],
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                _buildPostsTab(),
                _buildTodosTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    if (userDetailState.isLoadingPosts) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userDetailState.postsError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 50, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${userDetailState.postsError}'),
          ],
        ),
      );
    }

    final posts = userDetailState.posts ?? [];
    if (posts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 50, color: Colors.grey),
            SizedBox(height: 16),
            Text('No posts found'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (context, index) => _PostTile(post: posts[index]),
    );
  }

  Widget _buildTodosTab() {
    if (userDetailState.isLoadingTodos) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userDetailState.todosError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 50, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${userDetailState.todosError}'),
          ],
        ),
      );
    }

    final todos = userDetailState.todos ?? [];
    if (todos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_outlined, size: 50, color: Colors.grey),
            SizedBox(height: 16),
            Text('No todos found'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todos.length,
      itemBuilder: (context, index) => _TodoTile(todo: todos[index]),
    );
  }
}

class _PostTile extends StatelessWidget {
  final Post post;

  const _PostTile({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (post.isLocal) 
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'LOCAL',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const Spacer(),
                Text(
                  post.formattedDate,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              post.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              post.excerpt,
              style: const TextStyle(color: Colors.grey),
            ),
            if (post.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: post.tags.take(3).map((tag) => Chip(
                  label: Text(tag, style: const TextStyle(fontSize: 10)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )).toList(),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.thumb_up_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(post.reactions.formattedLikes, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 16),
                Icon(Icons.visibility_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(post.formattedViews, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TodoTile extends StatelessWidget {
  final Todo todo;

  const _TodoTile({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(
          todo.completed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: todo.completed ? Colors.green : Colors.grey,
        ),
        title: Text(
          todo.todo,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
            color: todo.completed ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.formattedCreatedDate.isNotEmpty)
              Text(todo.formattedCreatedDate),
            Row(
              children: [
                Text('${todo.category.emoji} ${todo.category.displayName}'),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(todo.priority).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    todo.priority.displayName,
                    style: TextStyle(
                      color: _getPriorityColor(todo.priority),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: todo.completed 
            ? const Icon(Icons.done, color: Colors.green)
            : null,
      ),
    );
  }

  Color _getPriorityColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.high:
        return Colors.red;
      case TodoPriority.medium:
        return Colors.orange;
      case TodoPriority.low:
        return Colors.blue;
    }
  }
}

class _CreatePostDialog extends StatefulWidget {
  final int userId;

  const _CreatePostDialog({required this.userId});

  @override
  State<_CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<_CreatePostDialog> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().initializeForm();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
        child: BlocConsumer<PostCubit, PostState>(
          listener: (context, state) {
            if (state is PostCreated) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post created successfully!')),
              );
            } else if (state is PostError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create New Post',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => context.read<PostCubit>().updateTitle(value),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _bodyController,
                  decoration: const InputDecoration(
                    labelText: 'Body',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  onChanged: (value) => context.read<PostCubit>().updateBody(value),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: state is PostCreating ? null : () {
                        context.read<PostCubit>().createPost(
                          title: _titleController.text,
                          body: _bodyController.text,
                          userId: widget.userId,
                        );
                      },
                      child: state is PostCreating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Create'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading user details...'),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading user details',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}