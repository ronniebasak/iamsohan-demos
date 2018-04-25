import time
from hashlib import sha256

class Block:
    def __init__(self, data=""):
        self.previous_hash=""
        self.data=data
        self.hash=""
        self.timestamp=int(time.time()) #only store the number of seconds
        self.nonce=0

    def calculate_hash(self):
        thash=sha256(self.previous_hash+self.data+str(self.timestamp)+str(self.nonce))
        return thash.hexdigest()

    def mine(self, difficulty):
        self.hash=self.calculate_hash()

        if self.hash[0:difficulty] != "0"*difficulty:
            self.nonce+=1
            self.mine(difficulty)
        else:
            return self.hash

    def __str__(self):
        return " :: ".join([self.data, str(self.timestamp), self.hash, self.previous_hash, str(self.nonce)])

class Blockchain:
    def __init__(self):
        self.difficulty=2
        self.blockchain=[] #list of blocks
        self.mine_first_block()

    def get_last_block(self):
        return self.blockchain[-1]
    
    def mine_first_block(self):
        b=Block("INITIAL DATA")
        b.mine(self.difficulty)
        self.blockchain.append(b)

    def add_block(self, data):
        b=Block(data)
        b.previous_hash=self.get_last_block().hash
        b.mine(self.difficulty)
        self.blockchain.append(b)

    def verify(self):
        for _block in xrange(len(self.blockchain)-1):
            block=self.blockchain[_block]
            block_n=self.blockchain[_block+1]
            if block.hash!=block_n.previous_hash:
                return False
        
        for block in self.blockchain:
            x = block.calculate_hash()
            if x!=block.hash:
                return False
        return True

    def __str__(self):
        v=map(str, self.blockchain)
        return "\n".join(v)


if __name__=="__main__":
    a=Blockchain()
    print "mining"
    a.add_block("lorem Ipsum dolor")
    a.add_block("sit amet")
    print a;
    print "Verification:", a.verify();
    print 
    print "Altering data"
    a.blockchain[1].data="XKCD"
    print a
    print "Verification", a.verify()
    
