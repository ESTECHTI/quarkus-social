package com.example.social.quarkussocial.domain.repository;

import java.util.List;

import com.example.social.quarkussocial.domain.model.Post;

import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class PostRepository implements PanacheRepository<Post> {

  // Buscar posts por usuário
  public List<Post> findByUser(Long userId) {
    return find("user.id", userId).list();
  }

  // Buscar posts por texto (case-sensitive)
  public List<Post> findByText(String text) {
    return find("LOWER(text) LIKE ?1", "%" + text.toLowerCase() + "%").list();
  }

  // Contar posts de um usuário
  public long countByUser(Long userId) {
    return count("user.id", userId);
  }

  // Método para criar uma nova postagem
  public void createPost(Post post) {
    if (post.getText() == null || post.getText().trim().isEmpty()) {
      throw new IllegalArgumentException("O texto da postagem não pode ser vazio.");
    }

    if (post.getUser() == null) {
      throw new IllegalArgumentException("A postagem deve estar associada a um usuário.");
    }

    // O @PrePersist será acionado automaticamente aqui
    persist(post);
  }
}
