<?php
include("../config/database.php");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $data = json_decode(file_get_contents("php://input"));

    // Vérifier que les données sont présentes
    if (!$data || !isset($data->email) || !isset($data->password)) {
        echo json_encode(["success" => 0, "message" => "Email et mot de passe requis"]);
        exit();
    }

    $email = trim($data->email);
    $password = trim($data->password);

    $stmt = $conn->prepare("SELECT id, nom, prenom, email, role FROM utilisateurs WHERE email = ? AND password = ? LIMIT 1");
    if (!$stmt) {
        echo json_encode(["success" => 0, "message" => "Erreur lors de la préparation de la requête"]);
        exit();
    }

    $stmt->bind_param("ss", $email, $password);
    $stmt->execute();
    $stmt->bind_result($userId, $nom, $prenom, $userEmail, $role);

    if ($stmt->fetch()) {

        // Préparer la réponse avec les infos de base
        $response = [
            "id" => (int) $userId,
            "nom" => $nom,
            "prenom" => $prenom,
            "email" => $userEmail,
            "role" => $role
        ];

        // Ajouter l'ID spécifique au rôle (enseignant_id ou etudiant_id)
        if ($role == 'enseignant') {
            $res = $conn->prepare("SELECT id FROM enseignants WHERE utilisateur_id = ? LIMIT 1");
            if ($res) {
                $res->bind_param("i", $userId);
                $res->execute();
                $res->bind_result($enseignantId);
                if ($res->fetch()) {
                    $response['enseignant_id'] = (int) $enseignantId;
                }
                $res->close();
            }
        } elseif ($role == 'etudiant') {
            $res = $conn->prepare("SELECT id, classe_id FROM etudiants WHERE utilisateur_id = ? LIMIT 1");
            if ($res) {
                $res->bind_param("i", $userId);
                $res->execute();
                $res->bind_result($etudiantId, $classeId);
                if ($res->fetch()) {
                    $response['etudiant_id'] = (int) $etudiantId;
                    $response['classe_id'] = (int) $classeId;
                }
                $res->close();
            }
        }

        echo json_encode([
            "success" => 1,
            "data" => $response
        ]);
    } else {
        echo json_encode([
            "success" => 0,
            "message" => "Email ou mot de passe incorrect"
        ]);
    }

    $stmt->close();
} else {
    echo json_encode([
        "success" => 0,
        "message" => "Méthode non autorisée"
    ]);
}
?>