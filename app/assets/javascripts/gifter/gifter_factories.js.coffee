GifterFactories = angular.module("GifterFactories", [])

class Suggestions
  constructor: ()->
    @characters = {}

  learn: (word, index)->

    index = index || 0

    if(index == word.length)
      @isWord = true;
    else if (index < word.length)
      char = word[index];
      subTrie = @characters[char] || new Trie()
      subTrie.learn(word, index+1)
      @characters[char] = subTrie

    return this

  getWords: (words, currentWord)->
    console.log("Running Get words")
    currentWord = currentWord || ""
    words = words || []

    if (@isWord)
      console.log(currentWord)
      words.push(currentWord)

    for char of @characters
      console.log("Searching Chars", char)
      nextWord = currentWord + char
      @characters[char].getWords(words, nextWord)

    return words


  find: (word, index)->
    index = index || 0;
    char = word[index]
    console.log char
    if (index < word.length - 1 && @characters[char])
      index += 1;
      return @characters[char].find(word, index)
    else
      return @characters[char]


  autoComplete: (prefix)->
    subTrie = @find(prefix)
    if (subTrie)
      return subTrie.getWords([], prefix)
    else
      return []

























GifterFactories.factory("Suggestions", [Suggestions])

