
List<Map<String, dynamic>> generateMCQ(String subject) {
  switch (subject.toLowerCase()) {
    case 'math':
      final mathQuestions = [
        {
          'question': 'What is 7 + 8?',
          'options': ['13', '14', '15', '16'],
          'correct_answer': '15',
        },
        {
          'question': 'What is the square root of 144?',
          'options': ['10', '11', '12', '13'],
          'correct_answer': '12',
        },
        {
          'question': 'If a triangle has angles 90°, 45°, and 45°, what type of triangle is it?',
          'options': ['Scalene', 'Equilateral', 'Right-angled', 'Isosceles'],
          'correct_answer': 'Right-angled',
        },
        {
          'question': 'What is the value of π (pi) to two decimal places?',
          'options': ['3.12', '3.14', '3.16', '3.18'],
          'correct_answer': '3.14',
        },
        {
          'question': 'What is 5! (5 factorial)?',
          'options': ['20', '60', '120', '150'],
          'correct_answer': '120',
        },
      ];
      return mathQuestions;
      
    case 'english':
      final englishQuestions = [
        {
          'question': 'Which is the synonym of "happy"?',
          'options': ['Sad', 'Joyful', 'Angry', 'Confused'],
          'correct_answer': 'Joyful',
        },
        {
          'question': 'What is the antonym of "brave"?',
          'options': ['Cowardly', 'Fearless', 'Courageous', 'Bold'],
          'correct_answer': 'Cowardly',
        },
        {
          'question': 'Which word is a noun?',
          'options': ['Run', 'Quickly', 'Happiness', 'Blue'],
          'correct_answer': 'Happiness',
        },
        {
          'question': 'Choose the correct spelling:',
          'options': ['Accomodate', 'Accommodate', 'Acommodate', 'Acommadate'],
          'correct_answer': 'Accommodate',
        },
        {
          'question': 'Which is the correct plural form?',
          'options': ['Goose', 'Gooses', 'Geese', 'Gooseses'],
          'correct_answer': 'Geese',
        },
      ];
      return englishQuestions;
      
    case 'sst':
      final sstQuestions = [
        {
          'question': 'Who was the first President of India?',
          'options': ['Mahatma Gandhi', 'Jawaharlal Nehru', 'Rajendra Prasad', 'Sardar Patel'],
          'correct_answer': 'Rajendra Prasad',
        },
        {
          'question': 'Which country is known as the Land of the Rising Sun?',
          'options': ['China', 'Japan', 'India', 'Australia'],
          'correct_answer': 'Japan',
        },
        {
          'question': 'When did India gain independence?',
          'options': ['1945', '1946', '1947', '1948'],
          'correct_answer': '1947',
        },
        {
          'question': 'Which is the longest river in the world?',
          'options': ['Nile', 'Amazon', 'Ganga', 'Yangtze'],
          'correct_answer': 'Nile',
        },
        {
          'question': 'Which Indian state is known as the "Spice Garden of India"?',
          'options': ['Kerala', 'Tamil Nadu', 'Goa', 'Assam'],
          'correct_answer': 'Kerala',
        },
      ];
      return sstQuestions;
      
    case 'science':
      final scienceQuestions = [
        {
          'question': 'What is the chemical formula of water?',
          'options': ['H2O', 'CO2', 'NaCl', 'O2'],
          'correct_answer': 'H2O',
        },
        {
          'question': 'What planet is known as the Red Planet?',
          'options': ['Earth', 'Mars', 'Jupiter', 'Saturn'],
          'correct_answer': 'Mars',
        },
        {
          'question': 'What gas do plants absorb from the atmosphere?',
          'options': ['Oxygen', 'Nitrogen', 'Carbon Dioxide', 'Hydrogen'],
          'correct_answer': 'Carbon Dioxide',
        },
        {
          'question': 'What is the boiling point of water?',
          'options': ['90°C', '95°C', '100°C', '105°C'],
          'correct_answer': '100°C',
        },
        {
          'question': 'Which part of the plant conducts photosynthesis?',
          'options': ['Root', 'Stem', 'Leaf', 'Flower'],
          'correct_answer': 'Leaf',
        },
      ];
      return scienceQuestions;
      
    default:
      return [{
        'question': 'Invalid subject. Please choose a valid subject.',
        'options': ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
        'correct_answer': 'Option 1',
      }];
  }
}
