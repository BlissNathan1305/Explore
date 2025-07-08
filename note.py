# note_app.py

NOTE_FILE = "notes.txt"

def add_note():
    """Adds a new note to the notes file."""
    note = input("Enter your note: ")
    with open(NOTE_FILE, "a") as file:
        file.write(note + "\n")
    print("Note added successfully!")

def view_notes():
    """Displays all notes from the notes file."""
    try:
        with open(NOTE_FILE, "r") as file:
            notes = file.readlines()
            if not notes:
                print("No notes yet. Add some!")
            else:
                print("\n--- Your Notes ---")
                for i, note in enumerate(notes):
                    print(f"{i + 1}. {note.strip()}")
                print("------------------")
    except FileNotFoundError:
        print("No notes yet. Add some!")

def delete_note():
    """Deletes a note from the notes file based on its number."""
    try:
        with open(NOTE_FILE, "r") as file:
            notes = file.readlines()

        if not notes:
            print("No notes to delete.")
            return

        print("\n--- Notes to Delete ---")
        for i, note in enumerate(notes):
            print(f"{i + 1}. {note.strip()}")
        print("-----------------------")

        try:
            note_to_delete_index = int(input("Enter the number of the note to delete: ")) - 1
            if 0 <= note_to_delete_index < len(notes):
                deleted_note = notes.pop(note_to_delete_index)
                with open(NOTE_FILE, "w") as file:
                    file.writelines(notes)
                print(f"Note '{deleted_note.strip()}' deleted successfully!")
            else:
                print("Invalid note number. Please try again.")
        except ValueError:
            print("Invalid input. Please enter a number.")
    except FileNotFoundError:
        print("No notes to delete.")

def main_menu():
    """Displays the main menu and handles user choices."""
    while True:
        print("\n--- Note Taking App ---")
        print("1. Add Note")
        print("2. View Notes")
        print("3. Delete Note")
        print("4. Exit")
        choice = input("Enter your choice (1-4): ")

        if choice == '1':
            add_note()
        elif choice == '2':
            view_notes()
        elif choice == '3':
            delete_note()
        elif choice == '4':
            print("Exiting Note Taking App. Goodbye!")
            break
        else:
            print("Invalid choice. Please enter a number between 1 and 4.")

if __name__ == "__main__":
    main_menu()
