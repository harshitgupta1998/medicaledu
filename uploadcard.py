import requests
import json

def create_deck(deck_id, name, description):
    decks_url = 'https://firestore.googleapis.com/v1/projects/medicaledu-ac337/databases/users-test/documents/decks'
    deck_body = {
        'fields': {
            'deck_id': {'stringValue': deck_id},
            'name': {'stringValue': name},
            'description': {'stringValue': description},
            'created_at': {'timestampValue': '2025-11-23T00:00:00Z'},
            'updated_at': {'timestampValue': '2025-11-23T00:00:00Z'},
        }
    }
    print('Creating deck...')
    res = requests.post(decks_url, headers={'Content-Type': 'application/json'}, data=json.dumps(deck_body))
    if res.status_code >= 200 and res.status_code < 300:
        print(f"Deck '{deck_id}' created successfully!")
    else:
        print(f"Deck creation failed: Status {res.status_code}\nBody: {res.text}")


def create_card(card_id, deck_id, image_url, text, general, radiographic_features, images_and_cases, flagged=False):
    cards_url = 'https://firestore.googleapis.com/v1/projects/medicaledu-ac337/databases/users-test/documents/flashcards'
    card_body = {
        'fields': {
            'card_id': {'stringValue': card_id},
            'deck_id': {'stringValue': deck_id},
            'image_url': {'stringValue': image_url},
            'text': {'stringValue': text},
            'general': {'stringValue': general},
            'radiographic_features': {'stringValue': radiographic_features},
            'images_and_cases': {'stringValue': images_and_cases},
            'created_at': {'timestampValue': '2025-11-23T00:00:00Z'},
            'updated_at': {'timestampValue': '2025-11-23T00:00:00Z'},
            'flagged': {'booleanValue': flagged},
        }
    }
    print(f'Creating card {card_id}...')
    res = requests.post(cards_url, headers={'Content-Type': 'application/json'}, data=json.dumps(card_body))
    if res.status_code >= 200 and res.status_code < 300:
        print(f"Card '{card_id}' created successfully!")
    else:
        print(f"Card creation failed: Status {res.status_code}\nBody: {res.text}")

if __name__ == '__main__':
    # Example usage
    create_deck('deck1', 'Anatomy Basics', 'A deck for basic anatomy flashcards')
    create_card(
        'card1', 'deck1', 'https://example.com/image1.jpg',
        'This is a sample flashcard text.',
        'General information about the flashcard.',
        'Radiographic features of the flashcard.',
        'Images and cases related to the flashcard.',
        False
    )
    create_card(
        'card2', 'deck1', 'https://example.com/image2.jpg',
        'Another sample flashcard text.',
        'General information about the second flashcard.',
        'Radiographic features of the second flashcard.',
        'Images and cases related to the second flashcard.',
        False
    )